import SwiftUI
import SwiftData
import DesignFoundation

struct TransactionsListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Transaction.date, order: .reverse) private var transactions: [Transaction]
    @Query(sort: \Category.name) private var categories: [Category]

    @State private var isPresentingAddTransaction = false

    var body: some View {
        NavigationStack {
            Group {
                if transactions.isEmpty {
                    DFEmptyState(
                        icon: "tray",
                        title: "No transactions yet",
                        message: "Log your first expense to start seeing insights.",
                        actionTitle: "Add Transaction",
                        onAction: { isPresentingAddTransaction = true }
                    )
                } else {
                    DFList(transactions, onDelete: deleteTransactions) { transaction in
                        DFEntityRow(
                            media: .systemImage(transaction.category?.icon ?? "questionmark.circle"),
                            title: transaction.note,
                            subtitle: transaction.category?.name ?? "Uncategorized",
                            trailing: .text(CurrencyFormat.string(transaction.amount))
                        )
                    }
                }
            }
            .navigationTitle("Transactions")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isPresentingAddTransaction = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .dfSheet(isPresented: $isPresentingAddTransaction) {
                AddTransactionView(categories: categories)
            }
        }
    }

    private func deleteTransactions(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(transactions[index])
        }
    }
}
