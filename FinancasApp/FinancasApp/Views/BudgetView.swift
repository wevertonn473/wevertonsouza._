import SwiftUI
import SwiftData

struct BudgetView: View {
    @Environment(\.modelContext) private var context
    @Query private var categories: [Category]
    @Query private var budgets: [Budget]
    @Query private var transactions: [Transaction]

    @State private var selectedMonth: Date = Date()
    @State private var editingCategory: Category?

    private let calendar = Calendar.current

    private var expenseCategories: [Category] {
        categories.filter { $0.type == .expense }.sorted { $0.name < $1.name }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    MonthSelector(month: $selectedMonth)
                    totalsCard

                    if expenseCategories.isEmpty {
                        ContentUnavailableView(
                            "Sem categorias de despesa",
                            systemImage: "target",
                            description: Text("Crie categorias de despesa para definir orçamentos.")
                        )
                        .padding(.top, 40)
                    } else {
                        ForEach(expenseCategories) { category in
                            BudgetRow(
                                category: category,
                                limit: limit(for: category),
                                spent: spent(for: category)
                            )
                            .contentShape(Rectangle())
                            .onTapGesture { editingCategory = category }
                        }
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Orçamento")
            .sheet(item: $editingCategory) { category in
                BudgetEditView(
                    category: category,
                    month: selectedMonth,
                    currentLimit: limit(for: category)
                )
            }
        }
    }

    // MARK: - Cálculos

    private func budget(for category: Category) -> Budget? {
        let (month, year) = selectedMonth.monthYear()
        return budgets.first {
            $0.category?.persistentModelID == category.persistentModelID
                && $0.month == month && $0.year == year
        }
    }

    private func limit(for category: Category) -> Double {
        budget(for: category)?.limit ?? 0
    }

    private func spent(for category: Category) -> Double {
        transactions
            .filter {
                $0.type == .expense
                    && $0.category?.persistentModelID == category.persistentModelID
                    && calendar.isDate($0.date, equalTo: selectedMonth, toGranularity: .month)
            }
            .reduce(0) { $0 + $1.amount }
    }

    private var totalBudget: Double {
        expenseCategories.reduce(0) { $0 + limit(for: $1) }
    }

    private var totalSpent: Double {
        expenseCategories.reduce(0) { $0 + spent(for: $1) }
    }

    private var totalsCard: some View {
        VStack(spacing: 10) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Gasto").font(.caption).foregroundStyle(.secondary)
                    Text(totalSpent.currencyBRL).font(.title3.bold())
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Orçamento").font(.caption).foregroundStyle(.secondary)
                    Text(totalBudget.currencyBRL).font(.title3.bold())
                }
            }
            ProgressView(value: min(totalSpent, totalBudget), total: max(totalBudget, 1))
                .tint(totalSpent > totalBudget && totalBudget > 0 ? .red : Color(hex: "FF1E76"))
            if totalBudget > 0 {
                Text(remainingLabel)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var remainingLabel: String {
        let remaining = totalBudget - totalSpent
        if remaining >= 0 {
            return "Restam \(remaining.currencyBRL) neste mês"
        } else {
            return "Você ultrapassou em \((-remaining).currencyBRL)"
        }
    }
}

/// Linha de orçamento de uma categoria, com barra de progresso.
struct BudgetRow: View {
    let category: Category
    let limit: Double
    let spent: Double

    private var progress: Double {
        guard limit > 0 else { return 0 }
        return min(spent / limit, 1)
    }

    private var isOver: Bool { limit > 0 && spent > limit }

    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 12) {
                Image(systemName: category.icon)
                    .foregroundStyle(.white)
                    .frame(width: 34, height: 34)
                    .background(category.color)
                    .clipShape(Circle())

                Text(category.name).font(.body.weight(.medium))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }

            if limit > 0 {
                ProgressView(value: min(spent, limit), total: limit)
                    .tint(isOver ? .red : category.color)
                HStack {
                    Text("\(spent.currencyBRL) de \(limit.currencyBRL)")
                        .font(.caption)
                        .foregroundStyle(isOver ? .red : .secondary)
                    Spacer()
                    Text("\(Int(progress * 100))%")
                        .font(.caption.bold())
                        .foregroundStyle(isOver ? .red : .secondary)
                }
            } else {
                HStack {
                    Text("Gasto: \(spent.currencyBRL)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("Definir orçamento")
                        .font(.caption)
                        .foregroundStyle(Color(hex: "FF1E76"))
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    BudgetView()
        .modelContainer(PreviewData.container)
}
