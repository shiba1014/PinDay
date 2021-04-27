//
//  NewEvent.swift
//  PinDay
//
//  Created by shiba on 2021/04/21.
//

import Foundation
import SwiftUI

class NewEvent: ObservableObject {

    private static let maxTitleCount: Int = 15

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
}
