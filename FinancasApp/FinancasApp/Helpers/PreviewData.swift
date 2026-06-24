import Foundation
import SwiftData

/// Container em memória com dados de exemplo para os previews do Xcode.
@MainActor
enum PreviewData {
    static let container: ModelContainer = {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(
            for: Transaction.self, Category.self, Budget.self,
            configurations: config
        )
        let context = container.mainContext

        let categories = SeedData.defaultCategories
        categories.forEach { context.insert($0) }

        let food = categories.first { $0.name == "Alimentação" }
        let transport = categories.first { $0.name == "Transporte" }
        let salary = categories.first { $0.name == "Salário" }
        let leisure = categories.first { $0.name == "Lazer" }

        let now = Date()
        let samples: [Transaction] = [
            Transaction(amount: 5000, note: "Salário do mês", date: now, type: .income, category: salary),
            Transaction(amount: 89.90, note: "Mercado", date: now, type: .expense, category: food),
            Transaction(amount: 32.50, note: "Uber", date: now, type: .expense, category: transport),
            Transaction(amount: 120, note: "Cinema", date: now, type: .expense, category: leisure),
            Transaction(amount: 47.80, note: "Almoço", date: now, type: .expense, category: food),
        ]
        samples.forEach { context.insert($0) }

        if let food {
            let (month, year) = now.monthYear()
            context.insert(Budget(limit: 600, month: month, year: year, category: food))
        }

        try? context.save()
        return container
    }()
}
