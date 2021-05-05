//
//  Event.swift
//  PinDay
//
//  Created by shiba on 2021/04/21.
//

import Foundation
import SwiftUI

class Event: ObservableObject, Identifiable {

    let id: UUID
    @Published var title: String
    @Published var pinnedDateType: PinnedDateType
    @Published var backgroundStyle: BackgroundStyle
    let createdAt: Date

    var isValid: Bool {
        !title.isEmpty && title.count <= Self.maxTitleCount
    }

    convenience init() {
        self.init(id: .init(), title: "", pinnedDateType: .past(date: Date()), backgroundStyle: .color(.gray), createdAt:  Date())
    }

    init(id: UUID, title: String, pinnedDateType: PinnedDateType, backgroundStyle: BackgroundStyle, createdAt: Date) {
        self.id = id
        self.title = title
        self.pinnedDateType = pinnedDateType
        self.backgroundStyle = backgroundStyle
        self.createdAt = createdAt
    }

    init(data: EventEntity) throws {
        guard let id = data.id,
              let title = data.title,
              let pinnedDate = data.pinnedDate,
              let createdAt = data.createdAt
        else {
            fatalError("Invalid data: \(data)")
        }

        if let colorData = data.backgroundColor, let color = UIColor.decode(colorData) {
            self.backgroundStyle = .color(color)
        }
        else if let imageData = data.backgroundImage, let image = UIImage.decode(imageData) {
            self.backgroundStyle = .image(image)
        }
        else {
            fatalError("Either color or image must heve valid value: \(data)")
        }

        self.id = id
        self.title = title
        self.pinnedDateType = .create(pinnedDate: pinnedDate, startDate: data.startDate)
        self.createdAt = createdAt
    }

    func update(pinnedDate: Date) {

        if pinnedDate.isFuture() {
            if case .future(_, let style) = pinnedDateType {
                pinnedDateType = .future(date: pinnedDate, style: style)
            }
            else {
                pinnedDateType = .future(date: pinnedDate, style: .countDown)
            }
        }
        else {
            pinnedDateType = .past(date: pinnedDate)
        }
    }

    func update(futureCountStyle: PinnedDateType.FutureCountStyle) throws {
        switch pinnedDateType {
        case .past:
            throw CountStyleError.pastPinnedDate

        case .future(let date, _):
            switch futureCountStyle {
            case .countDown:
                pinnedDateType = .future(date: date, style: futureCountStyle)
            case .progress(let from):
                if date.isFuture(than: from) {
                    pinnedDateType = .future(date: date, style: futureCountStyle)
                }
                else {
                    throw CountStyleError.futureStartDate
                }
            }
        }
    }

    @ViewBuilder
    func makeCounterView(size: EventViewSize) -> some View {

        switch self.pinnedDateType {

        case .past(let date):
            Text("\(Date().calcDayDiff(from: date)) days ago")
                .font(size.bodyFont)
                .foregroundColor(.white)

        case .future(let date, let style):
            switch style {

            case .countDown:
                Text("\(date.calcDayDiff()) days left")
                    .font(size.bodyFont)
                    .foregroundColor(.white)

            case .progress(let start):
                CircularDayProgressView(start: start, end: date, size: size)
                    .padding(.top, 4)
            }
        }
    }

    static func copy(_ event: Event) -> Event {
        Event(id: event.id, title: event.title, pinnedDateType: event.pinnedDateType, backgroundStyle: event.backgroundStyle, createdAt: event.createdAt)
    }
}

// MARK: Model
extension Event {
    static let maxTitleCount: Int = 15

    enum PinnedDateType {

        enum FutureCountStyle: Equatable, Identifiable {
            var id: String { description }

            case countDown
            case progress(from: Date)

            var description: String {
                switch self {
                case .countDown: return "Count Down"
                case .progress: return "Progress"
                }
            }

            static let allCases: [Self] = [.countDown, .progress(from: Date().beginning())]
        }

        case past(date: Date)
        case future(date: Date, style: FutureCountStyle)

        var date: Date {
            switch self {
            case .past(let date):
                return date
            case .future(let date, _):
                return date
            }
        }

        var startDate: Date? {
            switch self {
            case .past:
                return nil
            case .future(_, let style):
                if case .progress(let from) = style {
                    return from
                }
                return nil
            }
        }

        var style: FutureCountStyle? {
            switch self {
            case .past:
                return nil
            case .future(_, let style):
                return style
            }
        }

        static func create(pinnedDate: Date, startDate: Date?) -> Self {
            if pinnedDate.isFuture() {
                if let startDate = startDate {
                    return .future(date: pinnedDate, style: .progress(from: startDate))
                }
                else {
                    return .future(date: pinnedDate, style: .countDown)
                }
            }
            else {
                return .past(date: pinnedDate)
            }
        }
    }

    enum BackgroundStyle {
        case color(UIColor)
        case image(UIImage)

        var color: Color {
            switch self {
            case .color(let color): return Color(color)
            case .image: return .clear
            }
        }

        var image: Image? {
            switch self {
            case .color: return nil
            case .image(let image): return Image(uiImage: image)
            }
        }
    }

    enum CountStyleError: String, Error {
        case pastPinnedDate = "Cannot set countStyle for past pinnedDate."
        case futureStartDate = "Cannot set startDate after pinnedDate."
    }
}

// MARK: Mock
extension Event {
    static let pastMock: Event = {
        let event = Event()
        let date = Date().fixed(month: 1, day: 1)
        event.title = "\(date.year)"
        event.pinnedDateType = .past(date: date)
        return event
    }()

    static let countDownMock: Event = {
        let event = Event()
        event.title = "New Year"
        event.pinnedDateType = .future(date: Date().fixed(month: 1, day: 1).added(year: 1), style: .countDown)
        return event
    }()

    static let progressMock: Event = {
        let event = Event()
        let date = Date().fixed(month: 12, day: 31)
        event.title = "\(date.year)"
        event.pinnedDateType = .future(date: Date().fixed(month: 12, day: 31), style: .progress(from: Date().fixed(month: 1, day: 1)))
        return event
    }()
}
