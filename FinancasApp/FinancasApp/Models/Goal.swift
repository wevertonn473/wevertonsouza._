import Foundation
import SwiftData
import SwiftUI

/// Meta de economia (ex.: viagem, reserva de emergência).
@Model
final class Goal {
    var name: String
    var targetAmount: Double
    var currentAmount: Double
    var icon: String
    var colorHex: String
    /// Data limite opcional para alcançar a meta.
    var deadline: Date?
    var createdDate: Date

    init(
        name: String,
        targetAmount: Double,
        currentAmount: Double = 0,
        icon: String,
        colorHex: String,
        deadline: Date? = nil
    ) {
        self.name = name
        self.targetAmount = targetAmount
        self.currentAmount = currentAmount
        self.icon = icon
        self.colorHex = colorHex
        self.deadline = deadline
        self.createdDate = Date()
    }

    var color: Color { Color(hex: colorHex) }

    /// Progresso de 0 a 1.
    var progress: Double {
        guard targetAmount > 0 else { return 0 }
        return min(currentAmount / targetAmount, 1)
    }

    var remaining: Double {
        max(targetAmount - currentAmount, 0)
    }

    var isCompleted: Bool {
        currentAmount >= targetAmount && targetAmount > 0
    }

    /// Quanto seria preciso guardar por mês para bater a meta até o prazo.
    var suggestedMonthlyAmount: Double? {
        guard let deadline, remaining > 0 else { return nil }
        let months = Calendar.current.dateComponents([.month], from: Date(), to: deadline).month ?? 0
        guard months > 0 else { return remaining }
        return remaining / Double(months)
    }
}
