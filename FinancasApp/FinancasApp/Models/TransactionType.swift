import Foundation

/// Tipo de movimentação: entrada (receita) ou saída (despesa).
enum TransactionType: String, Codable, CaseIterable, Identifiable {
    case income
    case expense

    var id: String { rawValue }

    var label: String {
        switch self {
        case .income: return "Receita"
        case .expense: return "Despesa"
        }
    }

    var systemImage: String {
        switch self {
        case .income: return "arrow.down.circle.fill"
        case .expense: return "arrow.up.circle.fill"
        }
    }
}
