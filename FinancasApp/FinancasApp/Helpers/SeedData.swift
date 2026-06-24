import Foundation
import SwiftData

/// Insere categorias padrão na primeira execução do app.
enum SeedData {
    static func seedIfNeeded(_ context: ModelContext) {
        let existing = (try? context.fetchCount(FetchDescriptor<Category>())) ?? 0
        guard existing == 0 else { return }

        for category in defaultCategories {
            context.insert(category)
        }
        try? context.save()
    }

    static var defaultCategories: [Category] {
        [
            // Receitas
            Category(name: "Salário", icon: "dollarsign.circle.fill", colorHex: "34C759", type: .income),
            Category(name: "Freelance", icon: "laptopcomputer", colorHex: "30B0C7", type: .income),
            Category(name: "Investimentos", icon: "chart.line.uptrend.xyaxis", colorHex: "32ADE6", type: .income),
            Category(name: "Outros", icon: "plus.circle.fill", colorHex: "8E8E93", type: .income),

            // Despesas
            Category(name: "Alimentação", icon: "fork.knife", colorHex: "FF9500", type: .expense),
            Category(name: "Transporte", icon: "car.fill", colorHex: "5856D6", type: .expense),
            Category(name: "Moradia", icon: "house.fill", colorHex: "AF52DE", type: .expense),
            Category(name: "Lazer", icon: "gamecontroller.fill", colorHex: "FF2D55", type: .expense),
            Category(name: "Saúde", icon: "cross.case.fill", colorHex: "FF3B30", type: .expense),
            Category(name: "Compras", icon: "bag.fill", colorHex: "FF1E76", type: .expense),
            Category(name: "Contas", icon: "doc.text.fill", colorHex: "FFCC00", type: .expense),
            Category(name: "Educação", icon: "book.fill", colorHex: "9D1EFF", type: .expense),
        ]
    }
}
