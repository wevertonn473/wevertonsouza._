import Foundation
import SwiftData

/// Limite de gasto mensal para uma categoria de despesa.
@Model
final class Budget {
    var limit: Double
    /// Mês (1-12) ao qual o orçamento se refere.
    var month: Int
    var year: Int
    var category: Category?

    init(limit: Double, month: Int, year: Int, category: Category?) {
        self.limit = limit
        self.month = month
        self.year = year
        self.category = category
    }
}
