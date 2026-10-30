import SwiftUI
import DesignFoundation

struct ContentView: View {
    var body: some View {
        TabView {
            BudgetDashboardView()
                .tabItem { Label("Dashboard", systemImage: "chart.bar.doc.horizontal") }

            TransactionsListView()
                .tabItem { Label("Transactions", systemImage: "list.bullet") }

            InsightsView()
                .tabItem { Label("Insights", systemImage: "sparkles") }

            CategoriesView()
                .tabItem { Label("Categories", systemImage: "tag") }
        }
    }
}
