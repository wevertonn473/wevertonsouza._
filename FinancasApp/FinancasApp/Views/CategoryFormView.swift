import SwiftUI
import SwiftData

/// Formulário para criar ou editar uma categoria.
struct CategoryFormView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    private let editing: Category?

    @State private var name: String
    @State private var type: TransactionType
    @State private var icon: String
    @State private var colorHex: String

    private let icons: [String] = [
        "fork.knife", "car.fill", "house.fill", "gamecontroller.fill",
        "cross.case.fill", "bag.fill", "doc.text.fill", "book.fill",
        "dollarsign.circle.fill", "laptopcomputer", "chart.line.uptrend.xyaxis",
        "creditcard.fill", "gift.fill", "airplane", "pawprint.fill",
        "tshirt.fill", "wrench.and.screwdriver.fill", "phone.fill",
        "wifi", "bolt.fill", "drop.fill", "heart.fill", "graduationcap.fill",
        "tram.fill"
    ]

    init(category: Category? = nil) {
        self.editing = category
        _name = State(initialValue: category?.name ?? "")
        _type = State(initialValue: category?.type ?? .expense)
        _icon = State(initialValue: category?.icon ?? "tag.fill")
        _colorHex = State(initialValue: category?.colorHex ?? CategoryPalette.colors.first ?? "FF1E76")
    }

    private let columns = [GridItem(.adaptive(minimum: 48), spacing: 12)]

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Nome da categoria", text: $name)
                    Picker("Tipo", selection: $type) {
                        ForEach(TransactionType.allCases) { type in
                            Text(type.label).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
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
            .navigationTitle(editing == nil ? "Nova categoria" : "Editar categoria")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Salvar") { save() }
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private func save() {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        if let editing {
            editing.name = trimmed
            editing.type = type
            editing.icon = icon
            editing.colorHex = colorHex
        } else {
            context.insert(Category(name: trimmed, icon: icon, colorHex: colorHex, type: type))
        }
        dismiss()
    }
}

#Preview {
    CategoryFormView()
        .modelContainer(PreviewData.container)
}
