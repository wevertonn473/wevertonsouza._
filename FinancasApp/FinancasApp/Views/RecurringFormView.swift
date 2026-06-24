import SwiftUI
import SwiftData

/// Formulário para criar ou editar uma regra recorrente.
struct RecurringFormView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Category.name) private var categories: [Category]

    private let editing: RecurringRule?

    @State private var type: TransactionType
    @State private var amount: Double
    @State private var note: String
    @State private var frequency: RecurrenceFrequency
    @State private var startDate: Date
    @State private var hasInstallments: Bool
    @State private var installmentTotal: Int
    @State private var selectedCategory: Category?

    init(rule: RecurringRule? = nil) {
        self.editing = rule
        _type = State(initialValue: rule?.type ?? .expense)
        _amount = State(initialValue: rule?.amount ?? 0)
        _note = State(initialValue: rule?.note ?? "")
        _frequency = State(initialValue: rule?.frequency ?? .monthly)
        _startDate = State(initialValue: rule?.startDate ?? Date())
        _hasInstallments = State(initialValue: rule?.installmentTotal != nil)
        _installmentTotal = State(initialValue: rule?.installmentTotal ?? 12)
        _selectedCategory = State(initialValue: rule?.category)
    }

    private var availableCategories: [Category] {
        categories.filter { $0.type == type }
    }

    /// Edição de uma regra que já gerou parcelas: trava campos que bagunçariam o histórico.
    private var hasGenerated: Bool {
        (editing?.generatedCount ?? 0) > 0
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
                    .disabled(hasGenerated)
                }

                Section("Valor da parcela") {
                    TextField("0,00", value: $amount, format: .currency(code: "BRL"))
                        .keyboardType(.decimalPad)
                        .font(.title2.bold())
                }

                Section("Categoria") {
                    if availableCategories.isEmpty {
                        Text("Crie uma categoria de \(type.label.lowercased()) primeiro.")
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

                Section("Repetição") {
                    Picker("Frequência", selection: $frequency) {
                        ForEach(RecurrenceFrequency.allCases) { freq in
                            Text(freq.label).tag(freq)
                        }
                    }
                    .disabled(hasGenerated)

                    DatePicker("Início", selection: $startDate, displayedComponents: .date)
                        .disabled(hasGenerated)

                    Toggle("Tem número de parcelas", isOn: $hasInstallments)

                    if hasInstallments {
                        Stepper(value: $installmentTotal, in: 1...600) {
                            HStack {
                                Text("Total de parcelas")
                                Spacer()
                                Text("\(installmentTotal)x")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }

                Section("Detalhes") {
                    TextField("Descrição (ex.: Financiamento do carro)", text: $note)
                }

                if hasGenerated, let editing {
                    Section {
                        LabeledContent("Parcelas já lançadas", value: "\(editing.generatedCount)")
                    } footer: {
                        Text("Para mudar tipo, frequência ou data de início, exclua esta regra e crie uma nova. As parcelas já lançadas permanecem nas transações.")
                    }
                }
            }
            .navigationTitle(editing == nil ? "Nova recorrência" : "Editar recorrência")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: type) {
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
        let total = hasInstallments ? installmentTotal : nil

        if let editing {
            editing.amount = amount
            editing.note = note
            editing.category = selectedCategory
            editing.installmentTotal = total
            // Campos estruturais só mudam quando ainda não houve geração.
            if !hasGenerated {
                editing.type = type
                editing.frequency = frequency
                editing.startDate = startDate
            }
            // Reativa caso o usuário tenha aumentado o número de parcelas.
            if let total, editing.generatedCount < total {
                editing.isActive = true
            }
            RecurringEngine.generate(for: editing, in: context)
        } else {
            let rule = RecurringRule(
                amount: amount,
                note: note,
                type: type,
                frequency: frequency,
                startDate: startDate,
                installmentTotal: total,
                category: selectedCategory
            )
            context.insert(rule)
            // Materializa imediatamente quaisquer parcelas já vencidas.
            RecurringEngine.generate(for: rule, in: context)
        }
        dismiss()
    }
}

#Preview {
    RecurringFormView()
        .modelContainer(PreviewData.container)
}
