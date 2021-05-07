//
//  PinDayWidget.swift
//  PinDayWidget
//
//  Created by shiba on 2021/05/07.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {

    typealias Entry = EventEntry

    let events: [Event]

    init() {
        events = (try? PersistenceController.shared.fetchAllEvents()) ??  []
    }

    func placeholder(in context: Context) -> EventEntry {

        EventEntry(date: Date(), event: .mock, configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (EventEntry) -> ()) {
        let entry = EventEntry(date: Date(), event: .mock, configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [EventEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = EventEntry(date: entryDate, event: events.first, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct EventEntry: TimelineEntry {
    let date: Date
    let event: Event?
    let configuration: ConfigurationIntent
}

extension Event {
    static let mock: Event = {
        let event = Event.init(entity: Event.entity(), insertInto: nil)
        let date = Date().fixed(month: 12, day: 31).beginning()
        event.id = UUID()
        event.title = "\(date.year)"
        event.pinnedDate = date
        event.backgroundColor = Data.encode(color: .appOrange)
        event.createdAt = Date()
        return event
    }()
}

@main
struct PinDayWidget: Widget {
    let kind: String = "PinDayWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            PinDayWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct PinDayWidget_Previews: PreviewProvider {
    static var previews: some View {
        PinDayWidgetEntryView(entry: EventEntry(date: Date(), event: nil, configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
