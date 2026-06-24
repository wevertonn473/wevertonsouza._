import SwiftUI

/// Sheet compacto para adicionar (ou retirar) um valor de uma meta.
struct GoalContributionView: View {
    @Environment(\.dismiss) private var dismiss
    let goal: Goal

    @State private var value: Double = 0

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Image(systemName: goal.icon)
                            .foregroundStyle(.white)
                            .frame(width: 34, height: 34)
                            .background(goal.color)
                            .clipShape(Circle())
                        VStack(alignment: .leading) {
                            Text(goal.name).font(.headline)
                            Text("Faltam \(goal.remaining.currencyBRL)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Section("Valor a adicionar") {
                    TextField("0,00", value: $value, format: .currency(code: "BRL"))
                        .keyboardType(.decimalPad)
                        .font(.title2.bold())
                }
            }
            .navigationTitle("Aporte")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Adicionar") {
                        goal.currentAmount = max(goal.currentAmount + value, 0)
                        dismiss()
                    }
                    .disabled(value <= 0)
                }
            }
        }
    }
}
