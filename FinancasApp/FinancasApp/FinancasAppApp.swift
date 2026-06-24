import SwiftUI
import SwiftData

@main
struct FinancasAppApp: App {
    let container: ModelContainer

    init() {
        do {
            container = try ModelContainer(
                for: Transaction.self, Category.self, Budget.self,
                RecurringRule.self, Goal.self
            )
            SeedData.seedIfNeeded(container.mainContext)
            RecurringEngine.process(container.mainContext)
        } catch {
            fatalError("Não foi possível criar o ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(container)
    }
}
