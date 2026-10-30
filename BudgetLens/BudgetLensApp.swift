import SwiftUI
import SwiftData
import DesignFoundation

@main
struct BudgetLensApp: App {
    let modelContainer: ModelContainer

    init() {
        do {
            modelContainer = try ModelContainer(for: Category.self, Transaction.self)
        } catch {
            fatalError("Failed to create SwiftData ModelContainer: \(error)")
        }

        SampleData.seedIfNeeded(context: modelContainer.mainContext)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .dfThemePreset(.sage)
        }
        .modelContainer(modelContainer)
    }
}
