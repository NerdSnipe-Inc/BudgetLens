import Foundation

/// Pure aggregation over transactions/categories for the current calendar month — no SwiftData
/// or SwiftUI dependency, so the dashboard, AI insights, and unit tests all compute from the same
/// numbers.
struct BudgetSummary {
    struct CategorySpend: Identifiable {
        var id: String { category.name }
        let category: Category
        let spent: Double
        var remaining: Double { max(category.monthlyLimit - spent, 0) }
        var percentUsed: Double {
            guard category.monthlyLimit > 0 else { return 0 }
            return min(spent / category.monthlyLimit, 1.5)
        }
    }

    let monthTransactions: [Transaction]
    let categorySpend: [CategorySpend]
    let totalSpent: Double
    let totalBudget: Double
    let dailyTrend: [(label: String, value: Double)]
    let previousMonthTotal: Double

    var remaining: Double { max(totalBudget - totalSpent, 0) }

    var percentDelta: String {
        guard previousMonthTotal > 0 else { return "new" }
        let delta = (totalSpent - previousMonthTotal) / previousMonthTotal * 100
        return String(format: "%+.0f%%", delta)
    }

    var isSpendingUp: Bool { totalSpent > previousMonthTotal }

    static func compute(transactions: [Transaction], categories: [Category], now: Date = .now) -> BudgetSummary {
        let calendar = Calendar.current
        let monthInterval = calendar.dateInterval(of: .month, for: now) ?? DateInterval(start: now, end: now)
        let monthTransactions = transactions.filter { monthInterval.contains($0.date) }

        let previousMonthDate = calendar.date(byAdding: .month, value: -1, to: now) ?? now
        let previousInterval = calendar.dateInterval(of: .month, for: previousMonthDate) ?? DateInterval(start: previousMonthDate, end: previousMonthDate)
        let previousMonthTotal = transactions
            .filter { previousInterval.contains($0.date) }
            .reduce(0) { $0 + $1.amount }

        let categorySpend: [CategorySpend] = categories.map { category in
            let spent = monthTransactions
                .filter { $0.category?.name == category.name }
                .reduce(0) { $0 + $1.amount }
            return CategorySpend(category: category, spent: spent)
        }.sorted { $0.spent > $1.spent }

        let totalSpent = monthTransactions.reduce(0) { $0 + $1.amount }
        let totalBudget = categories.reduce(0) { $0 + $1.monthlyLimit }

        var dailyTotals: [Date: Double] = [:]
        for transaction in monthTransactions {
            let day = calendar.startOfDay(for: transaction.date)
            dailyTotals[day, default: 0] += transaction.amount
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        let dailyTrend = dailyTotals
            .sorted { $0.key < $1.key }
            .map { (label: formatter.string(from: $0.key), value: $0.value) }

        return BudgetSummary(
            monthTransactions: monthTransactions.sorted { $0.date > $1.date },
            categorySpend: categorySpend,
            totalSpent: totalSpent,
            totalBudget: totalBudget,
            dailyTrend: dailyTrend,
            previousMonthTotal: previousMonthTotal
        )
    }
}
