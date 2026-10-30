import SwiftUI
import SwiftData
import DesignFoundation

struct CategoriesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Category.name) private var categories: [Category]

    @State private var isPresentingAddCategory = false

    var body: some View {
        NavigationStack {
            Group {
                if categories.isEmpty {
                    DFEmptyState(
                        icon: "tag",
                        title: "No categories yet",
                        message: "Create a category with a monthly limit to start budgeting.",
                        actionTitle: "Add Category",
                        onAction: { isPresentingAddCategory = true }
                    )
                } else {
                    DFList(categories, onDelete: deleteCategories) { category in
                        DFEntityRow(
                            media: .systemImage(category.icon),
                            title: category.name,
                            subtitle: category.transactions.count == 1 ? "1 transaction" : "\(category.transactions.count) transactions",
                            trailing: .text(CurrencyFormat.string(category.monthlyLimit) + "/mo")
                        )
                    }
                }
            }
            .navigationTitle("Categories")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isPresentingAddCategory = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .dfSheet(isPresented: $isPresentingAddCategory) {
                CategoryFormView()
            }
        }
    }

    private func deleteCategories(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(categories[index])
        }
    }
}
