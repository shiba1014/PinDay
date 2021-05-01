//
//  Event.swift
//  PinDay
//
//  Created by shiba on 2021/04/21.
//

import Foundation
import SwiftUI

class Event: ObservableObject, Identifiable {

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
    }

    enum BackgroundStyle {
        case color(Color)
        case image(Image)
    }

    var id: UUID = .init()
    @Published var title: String = ""
    @Published var pinnedDateType: PinnedDateType = .past(date: Date())
    var isValid: Bool {
        !title.isEmpty && title.count <= Self.maxTitleCount
    }
    @Published var backgroundStyle: BackgroundStyle = .color(.gray)

    func update(pinnedDate: Date) {

        let date = pinnedDate.beginning()
        if date.isFuture() {
            if case .future(_, let style) = pinnedDateType {
                pinnedDateType = .future(date: date, style: style)
            }
            else {
                pinnedDateType = .future(date: date, style: .countDown)
            }
        }
        else if !date.isFuture() {
            pinnedDateType = .past(date: date)
        }
    }

    enum CountStyleError: String, Error {
        case pastPinnedDate = "Cannot set countStyle for past pinnedDate."
        case futureStartDate = "Cannot set startDate after pinnedDate."
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
    func makeCounterView() -> some View {

        switch self.pinnedDateType {

        case .past(let date):
            Text("\(Date().calcDayDiff(from: date)) days ago")
                .font(.body)
                .foregroundColor(.white)

        case .future(let date, let style):
            switch style {

            case .countDown:
                Text("\(date.calcDayDiff()) days left")
                    .font(.body)
                    .foregroundColor(.white)

            case .progress(let start):
                CircularDayProgressView(start: start, end: date)
            }
        }
    }

    // MARK: Mock
    static let pastMock: Event = {
        let event = Event()
        event.title = "This Year"
        event.pinnedDateType = .past(date: Date().fixed(month: 1, day: 1))
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
        event.title = "This Year"
        event.pinnedDateType = .future(date: Date().fixed(month: 12, day: 31), style: .progress(from: Date().fixed(month: 1, day: 1)))
        return event
    }()
}
