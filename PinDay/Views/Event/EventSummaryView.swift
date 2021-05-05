//
//  EventSummaryView.swift
//  PinDay
//
//  Created by Satsuki Hashiba on 2021/04/11.
//

import SwiftUI

fileprivate extension EventViewSize {
    var spacing: CGFloat {
        switch self {
        case .small, .medium: return 8
        case .fullscreen: return 16
        }
    }

    var padding: CGFloat {
        switch self {
        case .small, .medium: return 20
        case .fullscreen: return 40
        }
    }
}

struct EventSummaryView: View {
    private static let radius: CGFloat = 24

    @ObservedObject var event: Event
    let size: EventViewSize

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .bottom)) {

            EventBackgroundView(style: event.backgroundStyle, size: size)

            VStack(alignment: .leading, spacing: size.spacing) {
                Text(event.title)
                    .font(size.titleFont)
                    .foregroundColor(.white)

                event.makeCounterView(size: size)
            }
            .padding(size.padding)
        }
    }
}

struct EventSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        EventSummaryView(event: .countDownMock, size: .small)
            .padding()
    }
}

struct NewEventSummaryView: View {

    private let radius: CGFloat = 24

    static func pastMock(size: EventViewSize) -> NewEventSummaryView {
        let date = Date().fixed(month: 1, day: 1)
        return .init(
            title: "\(date.year)",
            pinnedDate: date,
            startDate: nil,
            color: Color(.yellow),
            image: nil,
            size: size
        )
    }

    static func countDownMock(size: EventViewSize) -> NewEventSummaryView {
        let date = Date().fixed(month: 1, day: 1).added(year: 1)
        return .init(
            title: "New Year",
            pinnedDate: date,
            startDate: nil,
            color: Color(.purple),
            image: nil,
            size: size
        )
    }

    static func progressMock(size: EventViewSize) -> NewEventSummaryView {
        let date = Date().fixed(month: 12, day: 31)
        return .init(
            title: "\(date.year)",
            pinnedDate: date,
            startDate: Date().fixed(month: 1, day: 1),
            color: Color(.orange),
            image: nil,
            size: size
        )
    }

    private let title: String
    private let pinnedDate: Date
    private let startDate: Date?
    private let color: Color?
    private let image: Image?
    private let size: EventViewSize

    private init(title: String, pinnedDate: Date, startDate: Date?, color: Color?, image: Image?, size: EventViewSize) {
        self.title = title
        self.pinnedDate = pinnedDate
        self.startDate = startDate
        self.color = color
        self.image = image
        self.size = size
    }

    init(entity: EventEntity, size: EventViewSize) {
        self.init(title: entity.title, pinnedDate: entity.pinnedDate, startDate: entity.startDate, color: entity.color, image: entity.image, size: size)
    }

    init(draft: EventDraft, size: EventViewSize) {
        self.init(title: draft.title, pinnedDate: draft.pinnedDate, startDate: draft.startDate, color: draft.color, image: draft.image, size: size)
    }

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .bottom)) {
            NewBackgroundView(color: color, image: image, size: size)

            VStack(alignment: .leading, spacing: size.spacing) {
                Text(title)
                    .font(size.titleFont)
                    .foregroundColor(.white)

                buildContentView()
            }
            .padding(size.padding)
        }
    }

    @ViewBuilder
    func buildContentView() -> some View {
        Group {
            if pinnedDate.isFuture() {
                if let startDate = startDate {
                    CircularDayProgressView(start: startDate, end: pinnedDate, size: size)
                }
                else {
                    Text("\(pinnedDate.calcDayDiff()) days left")
                        .font(size.bodyFont)
                        .foregroundColor(.white)
                }
            }
            else {
                Text("\(Date().calcDayDiff(from: pinnedDate)) days ago")
                    .font(size.bodyFont)
                    .foregroundColor(.white)
            }
        }
    }
}
