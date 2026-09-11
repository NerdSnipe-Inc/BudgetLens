import Foundation
import SwiftData

@MainActor
enum SampleData {

    /// Seeds a handful of categories and a month of transactions the first time the app
    /// launches, so the dashboard and AI insights have something real to show immediately
    /// instead of an empty state.
    static func seedIfNeeded(context: ModelContext) {
        let existing = try? context.fetch(FetchDescriptor<Category>())
        guard (existing ?? []).isEmpty else { return }

        let categories: [(String, String, Double, String)] = [
            ("Groceries", "cart.fill", 500, "success"),
            ("Dining Out", "fork.knife", 200, "warning"),
            ("Transport", "car.fill", 150, "accent"),
            ("Entertainment", "popcorn.fill", 100, "primary"),
            ("Subscriptions", "arrow.triangle.2.circlepath", 80, "destructive")
        ]

        var savedCategories: [Category] = []
        for (name, icon, limit, color) in categories {
            let category = Category(name: name, icon: icon, monthlyLimit: limit, colorName: color)
            context.insert(category)
            savedCategories.append(category)
        }

        let sampleTransactions: [(String, Double, String, Int)] = [
            ("Groceries", 64.20, "Trader Joe's", 1),
            ("Groceries", 48.10, "Whole Foods", 5),
            ("Dining Out", 22.50, "Corner Bistro", 2),
            ("Dining Out", 38.00, "Sushi Night", 8),
            ("Transport", 45.00, "Gas", 3),
            ("Transport", 18.75, "Parking", 6),
            ("Entertainment", 15.99, "Movie tickets", 4),
            ("Subscriptions", 9.99, "Streaming service", 1),
            ("Subscriptions", 12.99, "Music app", 1),
            ("Groceries", 71.40, "Costco run", 12)
        ]

        let calendar = Calendar.current
        for (categoryName, amount, note, daysAgo) in sampleTransactions {
            guard let category = savedCategories.first(where: { $0.name == categoryName }) else { continue }
            let date = calendar.date(byAdding: .day, value: -daysAgo, to: .now) ?? .now
            context.insert(Transaction(amount: amount, note: note, date: date, category: category))
        }

        try? context.save()
    }
}
