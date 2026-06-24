import SwiftUI
import SwiftData

struct CategoriesView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Category.name) private var categories: [Category]

    @State private var showingForm = false
    @State private var editingCategory: Category?

    private func categories(of type: TransactionType) -> [Category] {
        categories.filter { $0.type == type }
    }

    var body: some View {
        NavigationStack {
            List {
                section(title: "Receitas", type: .income)
                section(title: "Despesas", type: .expense)
            }
            .navigationTitle("Categorias")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showingForm = true } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingForm) {
                CategoryFormView()
            }
            .sheet(item: $editingCategory) { category in
                CategoryFormView(category: category)
            }
        }
    }

    private func section(title: String, type: TransactionType) -> some View {
        Section(title) {
            ForEach(categories(of: type)) { category in
                Button {
                    editingCategory = category
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: category.icon)
                            .foregroundStyle(.white)
                            .frame(width: 34, height: 34)
                            .background(category.color)
                            .clipShape(Circle())
                        Text(category.name)
                            .foregroundStyle(.primary)
                        Spacer()
                        Text("\(category.transactions.count)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .onDelete { offsets in
                delete(offsets, type: type)
            }
        }
    }

    private func delete(_ offsets: IndexSet, type: TransactionType) {
        let list = categories(of: type)
        for index in offsets {
            context.delete(list[index])
        }
    }
}

#Preview {
    CategoriesView()
        .modelContainer(PreviewData.container)
}
