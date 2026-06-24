import SwiftUI
import SwiftData

struct TransactionsView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Transaction.date, order: .reverse) private var transactions: [Transaction]

    @State private var showingForm = false
    @State private var editingTransaction: Transaction?

    private var grouped: [(date: Date, items: [Transaction])] {
        let calendar = Calendar.current
        let dict = Dictionary(grouping: transactions) {
            calendar.startOfDay(for: $0.date)
        }
        return dict.map { (date: $0.key, items: $0.value) }
            .sorted { $0.date > $1.date }
    }

    var body: some View {
        NavigationStack {
            Group {
                if transactions.isEmpty {
                    ContentUnavailableView(
                        "Nenhuma transação",
                        systemImage: "list.bullet.rectangle",
                        description: Text("Toque em + para registrar sua primeira receita ou despesa.")
                    )
                } else {
                    List {
                        ForEach(grouped, id: \.date) { group in
                            Section(header: Text(sectionTitle(for: group.date))) {
                                ForEach(group.items) { transaction in
                                    Button {
                                        editingTransaction = transaction
                                    } label: {
                                        TransactionRow(transaction: transaction)
                                    }
                                    .buttonStyle(.plain)
                                }
                                .onDelete { offsets in
                                    delete(offsets, in: group.items)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Transações")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingForm = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingForm) {
                TransactionFormView()
            }
            .sheet(item: $editingTransaction) { transaction in
                TransactionFormView(transaction: transaction)
            }
        }
    }

    private func sectionTitle(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "EEEE, d 'de' MMMM"
        let text = formatter.string(from: date)
        return text.prefix(1).uppercased() + text.dropFirst()
    }

    private func delete(_ offsets: IndexSet, in items: [Transaction]) {
        for index in offsets {
            context.delete(items[index])
        }
    }
}

/// Linha de uma transação na lista.
struct TransactionRow: View {
    let transaction: Transaction

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: transaction.category?.icon ?? "questionmark.circle")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(width: 38, height: 38)
                .background(transaction.category?.color ?? .gray)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(transaction.note.isEmpty ? (transaction.category?.name ?? "Transação") : transaction.note)
                    .font(.body)
                Text(transaction.category?.name ?? "Sem categoria")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(signedLabel)
                .font(.body.weight(.semibold))
                .foregroundStyle(transaction.type == .income ? Color(hex: "34C759") : Color.primary)
        }
        .padding(.vertical, 4)
    }

    private var signedLabel: String {
        let prefix = transaction.type == .income ? "+" : "−"
        return prefix + transaction.amount.currencyBRL
    }
}

#Preview {
    TransactionsView()
        .modelContainer(PreviewData.container)
}
