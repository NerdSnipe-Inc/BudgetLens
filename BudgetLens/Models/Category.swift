import Foundation
import SwiftData

@Model
final class Category {
    var name: String
    var icon: String
    var monthlyLimit: Double
    var colorName: String

    @Relationship(deleteRule: .nullify, inverse: \Transaction.category)
    var transactions: [Transaction] = []

    init(name: String, icon: String, monthlyLimit: Double, colorName: String) {
        self.name = name
        self.icon = icon
        self.monthlyLimit = monthlyLimit
        self.colorName = colorName
    }
}
