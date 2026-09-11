import Testing
import Foundation
@testable import BudgetLens

@Suite("BudgetSummary")
struct BudgetSummaryTests {
    @Test("computes total spend and remaining budget for the current month")
    func computesTotals() {
        let groceries = Category(name: "Groceries", icon: "cart.fill", monthlyLimit: 100, colorName: "success")
        let transactions = [
            Transaction(amount: 40, note: "Store A", date: .now, category: groceries),
            Transaction(amount: 20, note: "Store B", date: .now, category: groceries)
        ]

        let summary = BudgetSummary.compute(transactions: transactions, categories: [groceries])

        #expect(summary.totalSpent == 60)
        #expect(summary.totalBudget == 100)
        #expect(summary.remaining == 40)
        #expect(summary.categorySpend.first?.spent == 60)
    }

    @Test("excludes transactions from other months")
    func excludesOtherMonths() {
        let dining = Category(name: "Dining", icon: "fork.knife", monthlyLimit: 50, colorName: "warning")
        let lastMonth = Calendar.current.date(byAdding: .month, value: -1, to: .now) ?? .now
        let transactions = [
            Transaction(amount: 30, note: "This month", date: .now, category: dining),
            Transaction(amount: 999, note: "Last month", date: lastMonth, category: dining)
        ]

        let summary = BudgetSummary.compute(transactions: transactions, categories: [dining])

        #expect(summary.totalSpent == 30)
        #expect(summary.monthTransactions.count == 1)
    }

    @Test("caps percent used at 150% so a badly over-budget category doesn't blow out chart scale")
    func capsPercentUsed() {
        let subs = Category(name: "Subscriptions", icon: "arrow.triangle.2.circlepath", monthlyLimit: 10, colorName: "destructive")
        let transactions = [Transaction(amount: 100, note: "Overspend", date: .now, category: subs)]

        let summary = BudgetSummary.compute(transactions: transactions, categories: [subs])

        #expect(summary.categorySpend.first?.percentUsed == 1.5)
    }
}
