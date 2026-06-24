import Foundation
import SwiftData

/// Uma movimentação financeira (receita ou despesa).
@Model
final class Transaction {
    var amount: Double
    var note: String
    var date: Date
    var typeRaw: String
    var category: Category?

    var type: TransactionType {
        get { TransactionType(rawValue: typeRaw) ?? .expense }
        set { typeRaw = newValue.rawValue }
    }

    /// Valor com sinal: positivo para receitas, negativo para despesas.
    var signedAmount: Double {
        type == .income ? amount : -amount
    }

    init(amount: Double, note: String, date: Date, type: TransactionType, category: Category?) {
        self.amount = amount
        self.note = note
        self.date = date
        self.typeRaw = type.rawValue
        self.category = category
    }
}
