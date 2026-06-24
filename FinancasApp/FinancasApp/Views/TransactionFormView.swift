import SwiftUI
import SwiftData

/// Formulário para criar ou editar uma transação.
struct TransactionFormView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Category.name) private var categories: [Category]

    /// Transação sendo editada (nil quando é uma nova).
    private let editing: Transaction?

    @State private var type: TransactionType
    @State private var amount: Double
    @State private var note: String
    @State private var date: Date
    @State private var selectedCategory: Category?

    init(transaction: Transaction? = nil) {
        self.editing = transaction
        _type = State(initialValue: transaction?.type ?? .expense)
        _amount = State(initialValue: transaction?.amount ?? 0)
        _note = State(initialValue: transaction?.note ?? "")
        _date = State(initialValue: transaction?.date ?? Date())
        _selectedCategory = State(initialValue: transaction?.category)
    }

    private var availableCategories: [Category] {
        categories.filter { $0.type == type }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Tipo", selection: $type) {
                        ForEach(TransactionType.allCases) { type in
                            Text(type.label).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Valor") {
                    TextField("0,00", value: $amount, format: .currency(code: "BRL"))
                        .keyboardType(.decimalPad)
                        .font(.title2.bold())
                }

                Section("Categoria") {
                    if availableCategories.isEmpty {
                        Text("Nenhuma categoria de \(type.label.lowercased()). Crie uma na aba Categorias.")
                            .foregroundStyle(.secondary)
                    } else {
                        Picker("Categoria", selection: $selectedCategory) {
                            ForEach(availableCategories) { category in
                                Label(category.name, systemImage: category.icon)
                                    .tag(Optional(category))
                            }
                        }
                    }
                }

                Section("Detalhes") {
                    TextField("Descrição (opcional)", text: $note)
                    DatePicker("Data", selection: $date, displayedComponents: .date)
                }
            }
            .navigationTitle(editing == nil ? "Nova transação" : "Editar")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: type) {
                // Ao trocar o tipo, garante uma categoria coerente selecionada.
                if selectedCategory?.type != type {
                    selectedCategory = availableCategories.first
                }
            }
            .onAppear {
                if selectedCategory == nil {
                    selectedCategory = availableCategories.first
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Salvar") { save() }
                        .disabled(amount <= 0)
                }
            }
        }
    }

    private func save() {
        if let editing {
            editing.amount = amount
            editing.note = note
            editing.date = date
            editing.type = type
            editing.category = selectedCategory
        } else {
            let transaction = Transaction(
                amount: amount,
                note: note,
                date: date,
                type: type,
                category: selectedCategory
            )
            context.insert(transaction)
        }
        dismiss()
    }
}

#Preview {
    TransactionFormView()
        .modelContainer(PreviewData.container)
}
