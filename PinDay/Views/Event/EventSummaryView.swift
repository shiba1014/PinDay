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

    @State private var showSmartText: Bool = false
    @State private var now: Date = .init()
    private let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()

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

                HStack {
                    if showSmartText {
                        buildSmartSummaryView()
                    }
                    else {
                        buildSummaryView()
                    }
                    if size == .fullscreen {
                        Spacer()
                        Button(action: {
                            withAnimation {
                                showSmartText.toggle()
                            }
                        }) {
                            Image(systemName: showSmartText ? "lightbulb.fill" : "lightbulb")
                                .foregroundColor(.white)
                        }
                    }
                }

                if size == .fullscreen {
                    buildDetailText()
                        .font(.body)
                        .foregroundColor(.white)
                }
            }
            .padding(size.padding)
        }
        .onReceive(timer) { _ in
            now = Date()
        }
    }

    @ViewBuilder
    func buildSummaryView() -> some View {
        Group {
            if Calendar.gregorian.isDateInToday(pinnedDate) {
                Text("Today")
                    .font(size.bodyFont)
                    .foregroundColor(.white)
            }
            else if pinnedDate.isFuture() {
                if let startDate = startDate {
                    CircularDayProgressView(start: startDate, end: pinnedDate, now: now, size: size)
                        .padding(.vertical, 4)
                }
                else {
                    Text("\(Calendar.gregorian.days(from: Date(), to: pinnedDate)) days left")
                        .font(size.bodyFont)
                        .foregroundColor(.white)
                }
            }
            else {
                Text("\(Calendar.gregorian.days(from: pinnedDate, to: Date())) days ago")
                    .font(size.bodyFont)
                    .foregroundColor(.white)
            }
        }
    }

    func buildSmartSummaryView() -> Text {
        if pinnedDate.isFuture() {
            return Text("\(pinnedDate, style: .relative) left")
                .font(size.bodyFont)
                .foregroundColor(.white)
        }
        else {
            return Text("\(pinnedDate, style: .relative) ago")
                .font(size.bodyFont)
                .foregroundColor(.white)
        }
    }

    func buildDetailText() -> Text {
        if let startDate = startDate {
            let df = DateIntervalFormatter()
            df.locale = .current
            df.timeZone = .current
            df.dateTemplate = "ydMMM"
            return Text("\(df.string(from: startDate, to: pinnedDate))")
        }
        else {
            return Text(pinnedDate, style: .date)
        }
    }
}

struct EventSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        EventSummaryView(draft: .progressMock, size: .fullscreen)
    }
}
