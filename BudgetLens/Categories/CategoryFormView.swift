import SwiftUI
import DesignFoundation

struct CategoryFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var icon = "tag.fill"
    @State private var limitText = ""

    private let iconChoices = [
        "tag.fill", "cart.fill", "fork.knife", "car.fill", "popcorn.fill",
        "house.fill", "heart.fill", "airplane", "gift.fill", "bolt.fill"
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    DFTextField("Name", text: $name, placeholder: "Groceries")
                    DFTextField("Monthly Limit", text: $limitText, placeholder: "0.00")
                        #if os(iOS)
                        .keyboardType(.decimalPad)
                        #endif

                    Text("Icon")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 12) {
                        ForEach(iconChoices, id: \.self) { candidate in
                            Button {
                                icon = candidate
                            } label: {
                                Image(systemName: candidate)
                                    .frame(maxWidth: .infinity, minHeight: 40)
                                    .background(icon == candidate ? Color.accentColor.opacity(0.2) : Color.clear)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Add Category")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    DFButton("Cancel", style: .ghost) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    DFButton("Save") { save() }
                        .disabled(name.isEmpty || Double(limitText) == nil)
                }
            }
        }
    }

    private func save() {
        guard let limit = Double(limitText) else { return }
        let category = Category(name: name, icon: icon, monthlyLimit: limit, colorName: "primary")
        modelContext.insert(category)
        dismiss()
    }
}
