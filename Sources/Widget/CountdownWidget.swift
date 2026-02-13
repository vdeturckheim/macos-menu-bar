import WidgetKit
import SwiftUI

struct CountdownEntry: TimelineEntry {
    let date: Date
    let remaining: CountdownComponents?
}

struct CountdownTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> CountdownEntry {
        CountdownEntry(date: Date(), remaining: Countdown.remaining())
    }

    func getSnapshot(in context: Context, completion: @escaping (CountdownEntry) -> Void) {
        completion(CountdownEntry(date: Date(), remaining: Countdown.remaining()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CountdownEntry>) -> Void) {
        let now = Date()
        var entries: [CountdownEntry] = []

        // Generate entries every 15 minutes for the next 4 hours
        for minuteOffset in stride(from: 0, through: 240, by: 15) {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: now)!
            entries.append(CountdownEntry(date: entryDate, remaining: Countdown.remaining(from: entryDate)))
        }

        let timeline = Timeline(entries: entries, policy: .after(
            Calendar.current.date(byAdding: .hour, value: 4, to: now)!
        ))
        completion(timeline)
    }
}

// MARK: - Widget Views

struct RectangularWidgetView: View {
    let entry: CountdownEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(Countdown.eventName)
                .font(.headline)
                .widgetAccentable()
            if let remaining = entry.remaining {
                Text(remaining.shortFormatted)
                    .font(.system(.body, design: .monospaced))
            } else {
                Text("It's here!")
                    .font(.body)
            }
        }
    }
}

struct CircularWidgetView: View {
    let entry: CountdownEntry

    var body: some View {
        VStack(spacing: 1) {
            if let remaining = entry.remaining {
                Text("\(remaining.days)")
                    .font(.system(.title, design: .rounded).bold())
                    .widgetAccentable()
                Text("days")
                    .font(.caption2)
            } else {
                Text("🎉")
                    .font(.title)
            }
        }
    }
}

struct InlineWidgetView: View {
    let entry: CountdownEntry

    var body: some View {
        if let remaining = entry.remaining {
            Text("Demo Day in \(remaining.days)d \(String(format: "%02d", remaining.hours))h")
        } else {
            Text("Demo Day is here!")
        }
    }
}

struct SmallWidgetView: View {
    let entry: CountdownEntry

    var body: some View {
        VStack(spacing: 8) {
            YCLogoView(size: 40)
            if let remaining = entry.remaining {
                Text(remaining.shortFormatted)
                    .font(.system(.caption, design: .monospaced))
                    .fontWeight(.semibold)
                    .foregroundColor(YCBrand.orange)
            } else {
                Text("It's here!")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(YCBrand.orange)
            }
            Text(Countdown.eventName)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(8)
    }
}

// MARK: - Widget Configuration

struct CountdownWidget: Widget {
    let kind: String = "CountdownWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CountdownTimelineProvider()) { entry in
            CountdownWidgetEntryView(entry: entry)
        }
        .configurationDisplayName(Countdown.eventName)
        .description("Countdown to \(Countdown.eventName)")
        .supportedFamilies([
            .accessoryRectangular,
            .accessoryCircular,
            .accessoryInline,
            .systemSmall
        ])
    }
}

struct CountdownWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    let entry: CountdownEntry

    var body: some View {
        switch family {
        case .accessoryRectangular:
            RectangularWidgetView(entry: entry)
        case .accessoryCircular:
            CircularWidgetView(entry: entry)
        case .accessoryInline:
            InlineWidgetView(entry: entry)
        case .systemSmall:
            SmallWidgetView(entry: entry)
        default:
            SmallWidgetView(entry: entry)
        }
    }
}

@main
struct CountdownWidgetBundle: WidgetBundle {
    var body: some Widget {
        CountdownWidget()
    }
}
