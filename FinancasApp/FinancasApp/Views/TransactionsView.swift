import SwiftUI
import SwiftData

struct TransactionsView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Transaction.date, order: .reverse) private var transactions: [Transaction]
    @Query(sort: \Category.name) private var categories: [Category]

    @State private var showingForm = false
    @State private var editingTransaction: Transaction?

    // Busca e filtros
    @State private var searchText = ""
    @State private var filterType: TransactionType?
    @State private var filterCategoryID: PersistentIdentifier?

    private var isFiltering: Bool {
        filterType != nil || filterCategoryID != nil
    }

    private var filtered: [Transaction] {
        transactions.filter { transaction in
            if let filterType, transaction.type != filterType { return false }
            if let filterCategoryID,
               transaction.category?.persistentModelID != filterCategoryID { return false }
            if !searchText.isEmpty {
                let haystack = (transaction.note + " " + (transaction.category?.name ?? ""))
                    .lowercased()
                if !haystack.contains(searchText.lowercased()) { return false }
            }
            return true
        }
    }

    private var grouped: [(date: Date, items: [Transaction])] {
        let calendar = Calendar.current
        let dict = Dictionary(grouping: filtered) {
            calendar.startOfDay(for: $0.date)
        }
        return dict.map { (date: $0.key, items: $0.value) }
            .sorted { $0.date > $1.date }
    }

    private var filteredTotal: Double {
        filtered.reduce(0) { $0 + $1.signedAmount }
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
                } else if filtered.isEmpty {
                    ContentUnavailableView.search(text: searchText.isEmpty ? "filtros atuais" : searchText)
                } else {
                    List {
                        if isFiltering || !searchText.isEmpty {
                            Section {
                                HStack {
                                    Text("\(filtered.count) transações")
                                    Spacer()
                                    Text(filteredTotal.currencyBRL)
                                        .foregroundStyle(filteredTotal >= 0 ? Color(hex: "34C759") : .red)
                                }
                                .font(.subheadline)
                            }
                        }
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
            .searchable(text: $searchText, prompt: "Buscar por descrição ou categoria")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    filterMenu
                }
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

    private var filterMenu: some View {
        Menu {
            Picker("Tipo", selection: $filterType) {
                Text("Todos os tipos").tag(TransactionType?.none)
                ForEach(TransactionType.allCases) { type in
                    Text(type.label).tag(Optional(type))
                }
            }

            Picker("Categoria", selection: $filterCategoryID) {
                Text("Todas as categorias").tag(PersistentIdentifier?.none)
                ForEach(categories) { category in
                    Label(category.name, systemImage: category.icon)
                        .tag(Optional(category.persistentModelID))
                }
            }

            if isFiltering {
                Divider()
                Button("Limpar filtros", systemImage: "xmark.circle") {
                    filterType = nil
                    filterCategoryID = nil
                }
            }
        } label: {
            Image(systemName: isFiltering ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
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
