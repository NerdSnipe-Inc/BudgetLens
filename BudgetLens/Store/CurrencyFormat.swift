import Foundation

enum CurrencyFormat {
    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        return formatter
    }()

    static func string(_ value: Double) -> String {
        formatter.string(from: value as NSNumber) ?? "$\(Int(value))"
    }
}
