import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem { Label("Resumo", systemImage: "chart.pie.fill") }

            TransactionsView()
                .tabItem { Label("Transações", systemImage: "list.bullet") }

            BudgetView()
                .tabItem { Label("Orçamento", systemImage: "target") }

            CategoriesView()
                .tabItem { Label("Categorias", systemImage: "square.grid.2x2.fill") }
        }
        .tint(Color(hex: "FF1E76"))
    }
}

#Preview {
    MainTabView()
        .modelContainer(PreviewData.container)
}
