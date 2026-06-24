import SwiftUI
import SwiftData

/// Lista das regras recorrentes (financiamentos, salário, assinaturas).
/// Esta tela é empurrada a partir da aba "Mais", então não cria um NavigationStack próprio.
struct RecurringView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \RecurringRule.startDate, order: .reverse) private var rules: [RecurringRule]

    @State private var showingForm = false
    @State private var editingRule: RecurringRule?

    var body: some View {
        Group {
            if rules.isEmpty {
                ContentUnavailableView {
                    Label("Nenhuma recorrência", systemImage: "arrow.triangle.2.circlepath")
                } description: {
                    Text("Crie regras para lançar automaticamente parcelas de financiamento, salário ou assinaturas todo mês.")
                } actions: {
                    Button("Adicionar recorrência") { showingForm = true }
                        .buttonStyle(.borderedProminent)
                }
            } else {
                List {
                    ForEach(rules) { rule in
                        Button {
                            editingRule = rule
                        } label: {
                            RecurringRow(rule: rule)
                        }
                        .buttonStyle(.plain)
                    }
                    .onDelete(perform: delete)
                }
            }
        }
        .navigationTitle("Recorrentes")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { showingForm = true } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingForm) {
            RecurringFormView()
        }
        .sheet(item: $editingRule) { rule in
            RecurringFormView(rule: rule)
        }
    }

    private func delete(_ offsets: IndexSet) {
        for index in offsets {
            context.delete(rules[index])
        }
    }
}

/// Linha que resume uma regra recorrente.
struct RecurringRow: View {
    let rule: RecurringRule

    private var nextDate: Date? {
        guard rule.isActive else { return nil }
        if let total = rule.installmentTotal, rule.generatedCount >= total { return nil }
        return Calendar.current.date(
            byAdding: rule.frequency.component,
            value: rule.generatedCount,
            to: rule.startDate
        )
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: rule.category?.icon ?? "arrow.triangle.2.circlepath")
                .foregroundStyle(.white)
                .frame(width: 38, height: 38)
                .background(rule.category?.color ?? .gray)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 3) {
                Text(rule.note.isEmpty ? (rule.category?.name ?? "Recorrente") : rule.note)
                    .font(.body)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 3) {
                Text((rule.type == .income ? "+" : "−") + rule.amount.currencyBRL)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(rule.type == .income ? Color(hex: "34C759") : Color.primary)
                if let nextDate {
                    Text("Próx.: \(shortDate(nextDate))")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                } else {
                    Text("Concluído")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }

    private var subtitle: String {
        if let total = rule.installmentTotal {
            let remaining = max(total - rule.generatedCount, 0)
            return "\(rule.frequency.label) • \(rule.generatedCount)/\(total) pagas • faltam \(remaining)"
        }
        return "\(rule.frequency.label) • contínua"
    }

    private func shortDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: date)
    }
}

#Preview {
    NavigationStack {
        RecurringView()
    }
    .modelContainer(PreviewData.container)
}
