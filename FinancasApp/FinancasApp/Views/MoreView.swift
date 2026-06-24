import SwiftUI

/// Tela "Mais": agrupa as ferramentas de gerência (recorrentes e categorias).
struct MoreView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Automação") {
                    NavigationLink {
                        RecurringView()
                    } label: {
                        Label {
                            VStack(alignment: .leading) {
                                Text("Transações recorrentes")
                                Text("Financiamentos, salário, assinaturas")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        } icon: {
                            Image(systemName: "arrow.triangle.2.circlepath")
                        }
                    }
                }

                Section("Organização") {
                    NavigationLink {
                        CategoriesView()
                    } label: {
                        Label {
                            Text("Categorias")
                        } icon: {
                            Image(systemName: "square.grid.2x2.fill")
                        }
                    }
                }

                Section {
                    LabeledContent("Versão", value: "1.0")
                } header: {
                    Text("Sobre")
                } footer: {
                    Text("Seus dados ficam salvos apenas neste iPhone.")
                }
            }
            .navigationTitle("Mais")
        }
    }
}

#Preview {
    MoreView()
        .modelContainer(PreviewData.container)
}
