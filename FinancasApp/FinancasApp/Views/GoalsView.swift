import SwiftUI
import SwiftData

struct GoalsView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Goal.createdDate, order: .reverse) private var goals: [Goal]

    @State private var showingForm = false
    @State private var editingGoal: Goal?
    @State private var contributingGoal: Goal?

    var body: some View {
        NavigationStack {
            Group {
                if goals.isEmpty {
                    ContentUnavailableView {
                        Label("Nenhuma meta", systemImage: "flag.fill")
                    } description: {
                        Text("Crie metas como uma viagem ou reserva de emergência e acompanhe quanto já guardou.")
                    } actions: {
                        Button("Criar meta") { showingForm = true }
                            .buttonStyle(.borderedProminent)
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(goals) { goal in
                                GoalCard(
                                    goal: goal,
                                    onAdd: { contributingGoal = goal },
                                    onEdit: { editingGoal = goal }
                                )
                            }
                        }
                        .padding()
                    }
                    .background(Color(.systemGroupedBackground))
                }
            }
            .navigationTitle("Metas")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showingForm = true } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingForm) {
                GoalFormView()
            }
            .sheet(item: $editingGoal) { goal in
                GoalFormView(goal: goal)
            }
            .sheet(item: $contributingGoal) { goal in
                GoalContributionView(goal: goal)
                    .presentationDetents([.height(280)])
            }
        }
    }
}

/// Cartão de uma meta com barra de progresso e ações.
struct GoalCard: View {
    @Environment(\.modelContext) private var context
    let goal: Goal
    let onAdd: () -> Void
    let onEdit: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 12) {
                Image(systemName: goal.icon)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .background(goal.color)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 2) {
                    Text(goal.name).font(.headline)
                    if goal.isCompleted {
                        Label("Meta alcançada!", systemImage: "checkmark.seal.fill")
                            .font(.caption)
                            .foregroundStyle(Color(hex: "34C759"))
                    } else if let deadline = goal.deadline {
                        Text("Até \(formatted(deadline))")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
                Menu {
                    Button("Editar", systemImage: "pencil", action: onEdit)
                    Button("Excluir", systemImage: "trash", role: .destructive) {
                        context.delete(goal)
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(.secondary)
                        .frame(width: 30, height: 30)
                }
            }

            ProgressView(value: goal.progress)
                .tint(goal.color)

            HStack {
                Text(goal.currentAmount.currencyBRL)
                    .font(.subheadline.bold())
                Text("de \(goal.targetAmount.currencyBRL)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(Int(goal.progress * 100))%")
                    .font(.subheadline.bold())
                    .foregroundStyle(goal.color)
            }

            if !goal.isCompleted {
                if let monthly = goal.suggestedMonthlyAmount {
                    Text("Guarde \(monthly.currencyBRL)/mês para chegar lá")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Button {
                    onAdd()
                } label: {
                    Label("Adicionar valor", systemImage: "plus.circle.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .tint(goal.color)
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private func formatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    GoalsView()
        .modelContainer(PreviewData.container)
}
