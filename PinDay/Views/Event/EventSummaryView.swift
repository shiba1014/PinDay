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

    private let radius: CGFloat = 24

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

    init(event: Event, size: EventViewSize) {
        self.init(title: event.title, pinnedDate: event.pinnedDate, startDate: event.startDate, color: event.color, image: event.image, size: size)
    }

    init(draft: EventDraft, size: EventViewSize) {
        self.init(title: draft.title, pinnedDate: draft.pinnedDate, startDate: draft.startDate, color: draft.color, image: draft.image, size: size)
    }

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .bottom)) {
            EventBackgroundView(color: color, image: image, size: size)

            VStack(alignment: .leading, spacing: size.spacing) {
                Text(title)
                    .font(size.titleFont)
                    .foregroundColor(.white)

                buildSummaryView()

                if size == .fullscreen {
                    buildDetailText()
                        .font(.title2)
                        .foregroundColor(.white)
                }
            }
            .padding(size.padding)
        }
    }

    @ViewBuilder
    func buildSummaryView() -> some View {
        Group {
            if pinnedDate.isFuture() {
                if let startDate = startDate {
                    CircularDayProgressView(start: startDate, end: pinnedDate, size: size)
                        .padding(.vertical, 4)
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

    func buildDetailText() -> Text {
        if let startDate = startDate {
            return Text("from \(startDate.localized) to \(pinnedDate.localized)")
        }
        else {
            return Text(pinnedDate.localized)
        }
    }
}

struct EventSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        EventSummaryView(draft: .progressMock, size: .fullscreen)
    }
}
