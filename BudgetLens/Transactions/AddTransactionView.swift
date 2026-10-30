import SwiftUI
import DesignFoundation

struct AddTransactionView: View {
    let categories: [Category]

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var amountText = ""
    @State private var note = ""
    @State private var date = Date.now
    @State private var selectedCategoryName: String?

    private var selectedCategory: Category? {
        categories.first { $0.name == selectedCategoryName }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    DFTextField("Amount", text: $amountText, placeholder: "0.00")
                        #if os(iOS)
                        .keyboardType(.decimalPad)
                        #endif
                    DFTextField("Description", text: $note, placeholder: "Coffee, groceries, gas…")

                    if !categories.isEmpty {
                        DFPicker("Category", selection: $selectedCategoryName) {
                            ForEach(categories) { category in
                                Text(category.name).tag(Optional(category.name))
                            }
                        }
                    }

                    DFDatePicker("Date", selection: $date, in: Date.distantPast...Date.now)
                }
                .padding()
            }
            .navigationTitle("Add Transaction")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    DFButton("Cancel", style: .ghost) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    DFButton("Save") { save() }
                        .disabled(Double(amountText) == nil || note.isEmpty)
                }
            }
            .onAppear {
                selectedCategoryName = selectedCategoryName ?? categories.first?.name
            }
        }
    }

    private func save() {
        guard let amount = Double(amountText) else { return }
        let transaction = Transaction(amount: amount, note: note, date: date, category: selectedCategory)
        modelContext.insert(transaction)
        dismiss()
    }
}

