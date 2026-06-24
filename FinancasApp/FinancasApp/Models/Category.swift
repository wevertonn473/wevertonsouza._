import Foundation
import SwiftData
import SwiftUI

/// Categoria de uma transação (ex.: Alimentação, Salário).
@Model
final class Category {
    var name: String
    /// Nome de um SF Symbol usado como ícone.
    var icon: String
    /// Cor em hexadecimal (ex.: "FF9500").
    var colorHex: String
    /// Valor cru de `TransactionType` (receita/despesa).
    var typeRaw: String

    @Relationship(deleteRule: .nullify, inverse: \Transaction.category)
    var transactions: [Transaction] = []

    var type: TransactionType {
        get { TransactionType(rawValue: typeRaw) ?? .expense }
        set { typeRaw = newValue.rawValue }
    }

    var color: Color { Color(hex: colorHex) }

    init(name: String, icon: String, colorHex: String, type: TransactionType) {
        self.name = name
        self.icon = icon
        self.colorHex = colorHex
        self.typeRaw = type.rawValue
    }
}
