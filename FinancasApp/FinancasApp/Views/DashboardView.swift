import SwiftUI
import SwiftData
import Charts

struct DashboardView: View {
    @Query(sort: \Transaction.date, order: .reverse) private var transactions: [Transaction]

    @State private var selectedMonth: Date = Date()

    private let calendar = Calendar.current

    // MARK: - Dados derivados

    private var monthTransactions: [Transaction] {
        transactions.filter {
            calendar.isDate($0.date, equalTo: selectedMonth, toGranularity: .month)
        }
    }

    private var income: Double {
        monthTransactions.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
    }

    private var expense: Double {
        monthTransactions.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
    }

    private var balance: Double { income - expense }

    private struct CategorySlice: Identifiable {
        let id = UUID()
        let name: String
        let color: Color
        let total: Double
    }

    private var expenseByCategory: [CategorySlice] {
        let grouped = Dictionary(grouping: monthTransactions.filter { $0.type == .expense }) {
            $0.category?.name ?? "Sem categoria"
        }
        return grouped.map { name, txs in
            CategorySlice(
                name: name,
                color: txs.first?.category?.color ?? .gray,
                total: txs.reduce(0) { $0 + $1.amount }
            )
        }
        .sorted { $0.total > $1.total }
    }

    // MARK: - Corpo

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    MonthSelector(month: $selectedMonth)
                    balanceCard
                    incomeExpenseRow

                    if expenseByCategory.isEmpty {
                        emptyState
                    } else {
                        chartCard
                        breakdownCard
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Resumo")
        }
    }

    // MARK: - Componentes

    private var balanceCard: some View {
        VStack(spacing: 6) {
            Text("Saldo do mês")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(balance.currencyBRL)
                .font(.system(size: 38, weight: .bold, design: .rounded))
                .foregroundStyle(balance >= 0 ? Color.primary : Color.red)
                .contentTransition(.numericText())
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var incomeExpenseRow: some View {
        HStack(spacing: 14) {
            summaryTile(
                title: "Receitas",
                value: income,
                icon: "arrow.down.circle.fill",
                color: Color(hex: "34C759")
            )
            summaryTile(
                title: "Despesas",
                value: expense,
                icon: "arrow.up.circle.fill",
                color: Color(hex: "FF3B30")
            )
        }
    }

    private func summaryTile(title: String, value: Double, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: icon)
                .font(.subheadline)
                .foregroundStyle(color)
            Text(value.currencyBRL)
                .font(.title3.bold())
                .foregroundStyle(.primary)
                .minimumScaleFactor(0.7)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var chartCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Despesas por categoria")
                .font(.headline)

            Chart(expenseByCategory) { slice in
                SectorMark(
                    angle: .value("Total", slice.total),
                    innerRadius: .ratio(0.6),
                    angularInset: 1.5
                )
                .cornerRadius(4)
                .foregroundStyle(slice.color)
            }
            .frame(height: 220)
            .overlay {
                VStack(spacing: 2) {
                    Text("Total")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(expense.currencyBRL)
                        .font(.headline)
                        .minimumScaleFactor(0.6)
                        .lineLimit(1)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var breakdownCard: some View {
        VStack(spacing: 12) {
            ForEach(expenseByCategory) { slice in
                HStack {
                    Circle()
                        .fill(slice.color)
                        .frame(width: 12, height: 12)
                    Text(slice.name)
                    Spacer()
                    Text(slice.total.currencyBRL)
                        .foregroundStyle(.secondary)
                    Text(percentLabel(for: slice.total))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(width: 46, alignment: .trailing)
                }
                if slice.id != expenseByCategory.last?.id {
                    Divider()
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var emptyState: some View {
        ContentUnavailableView(
            "Sem despesas neste mês",
            systemImage: "tray",
            description: Text("Adicione transações na aba Transações para ver os gráficos aqui.")
        )
        .frame(maxWidth: .infinity)
        .padding(.top, 40)
    }

    private func percentLabel(for value: Double) -> String {
        guard expense > 0 else { return "0%" }
        return "\(Int((value / expense * 100).rounded()))%"
    }
}

#Preview {
    DashboardView()
        .modelContainer(PreviewData.container)
}
