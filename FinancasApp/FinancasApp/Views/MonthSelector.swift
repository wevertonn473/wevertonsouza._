import SwiftUI

/// Controle para navegar entre meses (◀︎ Junho 2026 ▶︎).
struct MonthSelector: View {
    @Binding var month: Date

    var body: some View {
        HStack {
            Button {
                withAnimation { month = month.adding(months: -1) }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.headline)
                    .frame(width: 44, height: 44)
            }

            Spacer()

            Text(month.monthTitle())
                .font(.headline)
                .contentTransition(.numericText())

            Spacer()

            Button {
                withAnimation { month = month.adding(months: 1) }
            } label: {
                Image(systemName: "chevron.right")
                    .font(.headline)
                    .frame(width: 44, height: 44)
            }
        }
        .padding(.horizontal, 4)
    }
}
