import Foundation
import SwiftData

/// Materializa transações reais a partir das regras recorrentes.
///
/// É idempotente: cada regra guarda quantas ocorrências já gerou (`generatedCount`),
/// então rodar o motor várias vezes nunca duplica lançamentos. Deve ser chamado
/// na inicialização do app e sempre que uma regra for criada/editada.
enum RecurringEngine {
    static func process(_ context: ModelContext, now: Date = Date()) {
        let rules = (try? context.fetch(FetchDescriptor<RecurringRule>())) ?? []
        var didChange = false

        for rule in rules where rule.isActive {
            didChange = generate(for: rule, in: context, now: now) || didChange
        }

        if didChange {
            try? context.save()
        }
    }

    /// Gera todas as ocorrências vencidas (data <= agora) ainda não materializadas.
    /// Retorna `true` se algo foi inserido/alterado.
    @discardableResult
    static func generate(for rule: RecurringRule, in context: ModelContext, now: Date = Date()) -> Bool {
        let calendar = Calendar.current
        var didChange = false

        while true {
            // Já gerou todas as parcelas previstas? Encerra a regra.
            if let total = rule.installmentTotal, rule.generatedCount >= total {
                if rule.isActive {
                    rule.isActive = false
                    didChange = true
                }
                break
            }

            // Próxima data = início + (n ocorrências já geradas) × frequência.
            guard let occurrence = calendar.date(
                byAdding: rule.frequency.component,
                value: rule.generatedCount,
                to: rule.startDate
            ) else { break }

            // Ainda não venceu: para por aqui até a próxima execução.
            if occurrence > now { break }

            let transaction = Transaction(
                amount: rule.amount,
                note: noteForOccurrence(rule: rule),
                date: occurrence,
                type: rule.type,
                category: rule.category
            )
            context.insert(transaction)
            rule.generatedCount += 1
            didChange = true
        }

        return didChange
    }

    /// Monta a descrição da transação, incluindo "(parcela/total)" quando aplicável.
    private static func noteForOccurrence(rule: RecurringRule) -> String {
        let base = rule.note.isEmpty ? (rule.category?.name ?? "Recorrente") : rule.note
        if let total = rule.installmentTotal {
            return "\(base) (\(rule.generatedCount + 1)/\(total))"
        }
        return base
    }
}
