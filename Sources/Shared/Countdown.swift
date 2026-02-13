import Foundation

struct CountdownComponents {
    let days: Int
    let hours: Int
    let minutes: Int
    let seconds: Int

    var formatted: String {
        String(format: "%dd %02dh %02dm %02ds", days, hours, minutes, seconds)
    }

    var shortFormatted: String {
        String(format: "%dd %02dh %02dm", days, hours, minutes)
    }
}

enum Countdown {
    /// YC Demo Day: Tuesday, June 16, 2026 at midnight in the user's local timezone
    static let targetDate: Date = {
        var components = DateComponents()
        components.year = 2026
        components.month = 6
        components.day = 16
        components.hour = 0
        components.minute = 0
        components.second = 0
        return Calendar.current.date(from: components)!
    }()

    static let eventName = "YC Demo Day"
    static let eventDateString = "Tuesday, June 16, 2026"

    /// Returns countdown components, or nil if the target date has passed.
    static func remaining(from now: Date = Date()) -> CountdownComponents? {
        guard now < targetDate else { return nil }
        let components = Calendar.current.dateComponents(
            [.day, .hour, .minute, .second],
            from: now,
            to: targetDate
        )
        return CountdownComponents(
            days: components.day ?? 0,
            hours: components.hour ?? 0,
            minutes: components.minute ?? 0,
            seconds: components.second ?? 0
        )
    }
}
