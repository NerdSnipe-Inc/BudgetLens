import Foundation
import SwiftData

@Model
final class Transaction {
    var amount: Double
    var note: String
    var date: Date
    var category: Category?

    init(amount: Double, note: String, date: Date = .now, category: Category? = nil) {
        self.amount = amount
        self.note = note
        self.date = date
        self.category = category
    }
}
