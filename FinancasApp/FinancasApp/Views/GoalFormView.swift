import SwiftUI
import SwiftData

/// Formulário para criar ou editar uma meta de economia.
struct GoalFormView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    private let editing: Goal?

    @State private var name: String
    @State private var targetAmount: Double
    @State private var currentAmount: Double
    @State private var icon: String
    @State private var colorHex: String
    @State private var hasDeadline: Bool
    @State private var deadline: Date

    private let icons: [String] = [
        "flag.fill", "airplane", "house.fill", "car.fill", "graduationcap.fill",
        "heart.fill", "gift.fill", "shield.fill", "creditcard.fill",
        "beach.umbrella.fill", "gamecontroller.fill", "laptopcomputer",
        "iphone", "pawprint.fill", "cross.case.fill", "star.fill"
    ]

    init(goal: Goal? = nil) {
        self.editing = goal
        _name = State(initialValue: goal?.name ?? "")
        _targetAmount = State(initialValue: goal?.targetAmount ?? 0)
        _currentAmount = State(initialValue: goal?.currentAmount ?? 0)
        _icon = State(initialValue: goal?.icon ?? "flag.fill")
        _colorHex = State(initialValue: goal?.colorHex ?? CategoryPalette.colors.first ?? "FF1E76")
        _hasDeadline = State(initialValue: goal?.deadline != nil)
        _deadline = State(initialValue: goal?.deadline ?? Calendar.current.date(byAdding: .month, value: 6, to: Date()) ?? Date())
    }

    private let columns = [GridItem(.adaptive(minimum: 48), spacing: 12)]

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Nome (ex.: Viagem, Reserva)", text: $name)
                }

                Section("Valor da meta") {
                    TextField("0,00", value: $targetAmount, format: .currency(code: "BRL"))
                        .keyboardType(.decimalPad)
                        .font(.title2.bold())
                }

                Section("Já guardado") {
                    TextField("0,00", value: $currentAmount, format: .currency(code: "BRL"))
                        .keyboardType(.decimalPad)
                }

                Section("Prazo") {
                    Toggle("Definir data limite", isOn: $hasDeadline)
                    if hasDeadline {
                        DatePicker("Até", selection: $deadline, in: Date()..., displayedComponents: .date)
                    }
                }

                Section("Cor") {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(CategoryPalette.colors, id: \.self) { hex in
                            Circle()
                                .fill(Color(hex: hex))
                                .frame(width: 40, height: 40)
                                .overlay {
                                    if hex == colorHex {
                                        Image(systemName: "checkmark")
                                            .foregroundStyle(.white)
                                            .font(.headline)
                                    }
                                }
                                .onTapGesture { colorHex = hex }
                        }
                    }
                    .padding(.vertical, 4)
                }

                Section("Ícone") {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(icons, id: \.self) { symbol in
                            Image(systemName: symbol)
                                .font(.title3)
                                .frame(width: 44, height: 44)
                                .foregroundStyle(symbol == icon ? .white : Color.primary)
                                .background(symbol == icon ? Color(hex: colorHex) : Color(.secondarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .onTapGesture { icon = symbol }
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle(editing == nil ? "Nova meta" : "Editar meta")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Salvar") { save() }
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty || targetAmount <= 0)
                }
            }
        }
    }

    private func save() {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        if let editing {
            editing.name = trimmed
            editing.targetAmount = targetAmount
            editing.currentAmount = currentAmount
            editing.icon = icon
            editing.colorHex = colorHex
            editing.deadline = hasDeadline ? deadline : nil
        } else {
            let goal = Goal(
                name: trimmed,
                targetAmount: targetAmount,
                currentAmount: currentAmount,
                icon: icon,
                colorHex: colorHex,
                deadline: hasDeadline ? deadline : nil
            )
            context.insert(goal)
        }
        dismiss()
    }
}

#Preview {
    GoalFormView()
        .modelContainer(PreviewData.container)
}
