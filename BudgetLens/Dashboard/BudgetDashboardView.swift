import SwiftUI
import SwiftData
import DesignFoundation
import DesignFoundationPro

/// The "Dashboard" tab — a personal-finance readout assembled entirely from
/// DesignFoundationPro's `Analytics` vertical (`DFAnalyticsOverviewScreen` and its stat
/// card / chart / activity-feed blocks) instead of a hand-built layout. Only the data
/// mapping below is app-specific; every pixel comes from the package.
struct BudgetDashboardView: View {
    @Query(sort: \Transaction.date, order: .reverse) private var transactions: [Transaction]
    @Query(sort: \Category.name) private var categories: [Category]

    private var summary: BudgetSummary {
        BudgetSummary.compute(transactions: transactions, categories: categories)
    }

    var body: some View {
        NavigationStack {
            DFAnalyticsOverviewScreen(configuration: configuration)
        }
    }

    private var configuration: DFAnalyticsOverviewScreen.Configuration {
        let summary = summary

        let heroMetrics: [DFAnalyticsOverviewScreen.HeroMetric] = [
            .init(
                label: "Spent This Month",
                value: CurrencyFormat.string(summary.totalSpent),
                delta: summary.percentDelta,
                deltaIsPositive: !summary.isSpendingUp
            ),
            .init(
                label: "Remaining",
                value: CurrencyFormat.string(summary.remaining),
                delta: summary.totalBudget > 0
                    ? "\(Int((summary.remaining / summary.totalBudget) * 100))% of budget"
                    : "no budget set",
                deltaIsPositive: summary.remaining > 0
            ),
            .init(
                label: "Total Budget",
                value: CurrencyFormat.string(summary.totalBudget),
                delta: "\(categories.count) categories",
                deltaIsPositive: true
            )
        ]

        let secondaryMetrics: [DFStatCardBlock.Configuration] = summary.categorySpend.prefix(6).map { entry in
            .init(
                title: entry.category.name,
                value: CurrencyFormat.string(entry.spent),
                trend: "of \(CurrencyFormat.string(entry.category.monthlyLimit))",
                trendDirection: entry.percentUsed >= 1 ? .down : .up,
                icon: entry.category.icon
            )
        }

        let activityItems: [DFActivityFeedRow.Configuration] = summary.monthTransactions.prefix(5).map { transaction in
            .init(
                initials: String((transaction.category?.name ?? "?").prefix(2)).uppercased(),
                title: transaction.note,
                subtitle: transaction.category?.name ?? "Uncategorized",
                timestamp: transaction.date.formatted(.relative(presentation: .named))
            )
        }

        return .init(
            heroMetrics: heroMetrics,
            secondaryMetrics: secondaryMetrics,
            trendChartData: summary.dailyTrend,
            breakdownChartData: summary.categorySpend.map { (label: $0.category.name, value: $0.spent) },
            activityItems: activityItems
        )
    }
}
