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

    var body: some View {

        entry.event.map { event in
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
    }

    @ViewBuilder
    func buildSummaryView(_ event: Event) -> some View {
        Group {
            if event.pinnedDate.isFuture() {
                if let startDate = event.startDate {
                    WidgetCircularDayProgressView(start: startDate, end: event.pinnedDate)
                        .padding(.vertical, 4)
                }
                else {
                    Text("\(event.pinnedDate.calcDayDiff()) days left")
                        .font(.body)
                        .foregroundColor(.white)
                }
            }
            else {
                Text("\(Date().calcDayDiff(from: event.pinnedDate)) days ago")
                    .font(.body)
                    .foregroundColor(.white)
            }
        }
    }
}

struct WidgetCircularDayProgressView: View {

    let start: Date
    let end: Date

    private let timer = Timer.publish(every: 3600, on: .current, in: .common).autoconnect()

    @State private var progress: Float

    init(start: Date, end: Date) {
        self.start = start
        self.end = end
        _progress = State<Float>(initialValue: Date.calcProgress(from: start, to: end))
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

            Text("\(Int(progress*100))%")
                .font(.body)
                .foregroundColor(.white)

        }
        .onReceive(timer) { _ in
            progress = Date.calcProgress(from: start, to: end)
        }
    }
}
