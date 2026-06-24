import Foundation

/// Formatação de valores em Real (pt-BR).
enum CurrencyFormatter {
    static let brl: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter
    }()

    static func string(from value: Double) -> String {
        brl.string(from: NSNumber(value: value)) ?? "R$ 0,00"
    }
}

extension Double {
    var currencyBRL: String { CurrencyFormatter.string(from: self) }
}
