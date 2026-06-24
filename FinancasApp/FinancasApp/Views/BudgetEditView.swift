import SwiftUI
import SwiftData

/// Define ou edita o limite de orçamento de uma categoria em um mês.
struct BudgetEditView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Query private var budgets: [Budget]

    let category: Category
    let month: Date
    let currentLimit: Double

    @State private var limit: Double

    init(category: Category, month: Date, currentLimit: Double) {
        self.category = category
        self.month = month
        self.currentLimit = currentLimit
        _limit = State(initialValue: currentLimit)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Image(systemName: category.icon)
                            .foregroundStyle(.white)
                            .frame(width: 34, height: 34)
                            .background(category.color)
                            .clipShape(Circle())
                        Text(category.name).font(.headline)
                    }
                }

                Section("Limite para \(month.monthTitle())") {
                    TextField("0,00", value: $limit, format: .currency(code: "BRL"))
                        .keyboardType(.decimalPad)
                        .font(.title2.bold())
                }

                if currentLimit > 0 {
                    Section {
                        Button("Remover orçamento", role: .destructive) {
                            removeExisting()
                            dismiss()
                        }
                    }
                }
            }
            .navigationTitle("Orçamento")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Salvar") { save() }
                        .disabled(limit <= 0)
                }
            }
        }
    }

    private func existingBudget() -> Budget? {
        let (m, y) = month.monthYear()
        return budgets.first {
            $0.category?.persistentModelID == category.persistentModelID
                && $0.month == m && $0.year == y
        }
    }

    private func save() {
        let (m, y) = month.monthYear()
        if let existing = existingBudget() {
            existing.limit = limit
        } else {
            context.insert(Budget(limit: limit, month: m, year: y, category: category))
        }
        dismiss()
    }

    private func removeExisting() {
        if let existing = existingBudget() {
            context.delete(existing)
        }
    }
}
