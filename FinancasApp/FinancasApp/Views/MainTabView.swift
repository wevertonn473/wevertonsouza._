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

            GoalsView()
                .tabItem { Label("Metas", systemImage: "flag.fill") }

            MoreView()
                .tabItem { Label("Mais", systemImage: "ellipsis.circle.fill") }
        }
        .tint(Color(hex: "FF1E76"))
    }
}

#Preview {
    MainTabView()
        .modelContainer(PreviewData.container)
}
