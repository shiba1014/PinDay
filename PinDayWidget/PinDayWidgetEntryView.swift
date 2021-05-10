//
//  PinDayWidgetEntryView.swift
//  PinDay
//
//  Created by shiba on 2021/05/07.
//

import WidgetKit
import SwiftUI

struct PinDayWidgetEntryView : View {

    var entry: Provider.Entry
    private let event: WidgetEvent?

    init(entry: Provider.Entry) {
        self.entry = entry
        self.event = entry.event
    }

    var body: some View {
        if let event = event {
            buildWidgetView(event)
                .widgetURL(URL(string: "pinday://deeplink?from=widget&id=\(event.id)"))
        }
        else {
            buildPlaceholder()
        }
    }

    @ViewBuilder
    func buildPlaceholder() -> some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .bottom)) {

            Rectangle()
                .fill(Color(.gray))

            VStack(alignment: .leading, spacing: 8) {
                Text("PinDay")
                    .font(Font.title2)
                    .foregroundColor(.white)

                Text("Please choose your event")
                    .font(.body)
                    .foregroundColor(.white)
            }
            .padding()
        }
    }

    @ViewBuilder
    func buildWidgetView(_ event: WidgetEvent) -> some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .bottom)) {

            Rectangle()
                .fill(event.color ?? .clear)
                .background(
                    event.image.map {
                        $0.resizable().aspectRatio(contentMode: .fill)
                    }
                )
                .if(event.image != nil) {
                    $0.overlay(
                        LinearGradient(
                            gradient: Gradient(
                                stops: [
                                    .init(color: .clear, location: 0.0),
                                    .init(color: Color.black.opacity(0.5), location: 1.0)
                                ]
                            ),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }

            VStack(alignment: .leading, spacing: 8) {
                Text(event.title)
                    .font(Font.title2.weight(.medium))
                    .foregroundColor(.white)

                buildSummaryView(event)
            }
            .padding()
        }
    }

    @ViewBuilder
    func buildSummaryView(_ event: WidgetEvent) -> some View {
        Group {
            if event.pinnedDate.isToday() {
                Text("Today")
                    .font(.body)
                    .foregroundColor(.white)
            }
            else if event.pinnedDate.isFuture() {
                if let startDate = event.startDate {
                    WidgetCircularDayProgressView(start: startDate, end: event.pinnedDate, now: entry.date)
                        .padding(.vertical, 4)
                }
                else {
                    Text("\(event.pinnedDate.calcDayDiff(from: entry.date)) days left")
                        .font(.body.bold())
                        .foregroundColor(.white)
                }
            }
            else {
                Text("\(entry.date.calcDayDiff(from: event.pinnedDate)) days ago")
                    .font(.body.bold())
                    .foregroundColor(.white)
            }
        }
    }
}

struct WidgetCircularDayProgressView: View {

    private var progress: Double

    init(start: Date, end: Date, now: Date) {
        progress = (now - start) / (end - start)
    }

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .stroke(lineWidth: 7)
                    .opacity(0.3)
                    .foregroundColor(.white)

                Circle()
                    .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                    .stroke(
                        style: .init(
                            lineWidth: 7,
                            lineCap: .round,
                            lineJoin: .round
                        )
                    )
                    .foregroundColor(.white)
                    .rotationEffect(Angle(degrees: 270.0))
            }
            .frame(width: 40, height: 40)

            Text("\(Int(round(progress*100)))%")
                .font(.body.bold())
                .foregroundColor(.white)

        }
    }
}
