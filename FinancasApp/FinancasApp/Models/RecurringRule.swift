import Foundation
import SwiftData

/// Regra de uma transação que se repete (ex.: parcela de financiamento, salário,
/// assinatura). O app gera transações reais a partir desta regra conforme as
/// datas vão vencendo.
@Model
final class RecurringRule {
    var amount: Double
    var note: String
    var typeRaw: String
    var frequencyRaw: String
    /// Data da primeira ocorrência.
    var startDate: Date
    /// Número total de parcelas. `nil` significa recorrência sem fim.
    var installmentTotal: Int?
    /// Quantas ocorrências já foram geradas como transações.
    var generatedCount: Int
    /// Quando `false`, o app para de gerar novas ocorrências.
    var isActive: Bool
    var category: Category?

    var type: TransactionType {
        get { TransactionType(rawValue: typeRaw) ?? .expense }
        set { typeRaw = newValue.rawValue }
    }

    var frequency: RecurrenceFrequency {
        get { RecurrenceFrequency(rawValue: frequencyRaw) ?? .monthly }
        set { frequencyRaw = newValue.rawValue }
    }

    /// Parcelas restantes (nil quando a recorrência é infinita).
    var remainingInstallments: Int? {
        guard let total = installmentTotal else { return nil }
        return max(total - generatedCount, 0)
    }

    init(
        amount: Double,
        note: String,
        type: TransactionType,
        frequency: RecurrenceFrequency,
        startDate: Date,
        installmentTotal: Int?,
        category: Category?
    ) {
        self.amount = amount
        self.note = note
        self.typeRaw = type.rawValue
        self.frequencyRaw = frequency.rawValue
        self.startDate = startDate
        self.installmentTotal = installmentTotal
        self.generatedCount = 0
        self.isActive = true
        self.category = category
    }
}
