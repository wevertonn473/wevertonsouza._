import Foundation

extension Date {
    /// Componentes de mês e ano deste date.
    func monthYear(calendar: Calendar = .current) -> (month: Int, year: Int) {
        let components = calendar.dateComponents([.month, .year], from: self)
        return (components.month ?? 1, components.year ?? 2000)
    }

    /// Nome do mês e ano capitalizado (ex.: "Junho 2026").
    func monthTitle(calendar: Calendar = .current) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "LLLL yyyy"
        let text = formatter.string(from: self)
        return text.prefix(1).uppercased() + text.dropFirst()
    }

    /// Avança ou retrocede `value` meses a partir deste date.
    func adding(months value: Int, calendar: Calendar = .current) -> Date {
        calendar.date(byAdding: .month, value: value, to: self) ?? self
    }
}
