//
//  NewEvent.swift
//  PinDay
//
//  Created by shiba on 2021/04/21.
//

import Foundation

class NewEvent: ObservableObject {

    enum CountStyle {
        case countUp
        case countDown
        case progress(from: Date)

        func isFutureStyle() -> Bool {
            switch self {
            case .countUp:
                return false
            case .countDown, .progress:
                return true
            }
        }

        static let futureDefault: Self = .countDown
        static let pastDefault: Self = .countUp
    }

    @Published var title: String = ""
    @Published var pinnedDate: Date = .init()
    @Published var countStyle: CountStyle = .countUp

    func updatePinnedDate(_ date: Date) {
        pinnedDate = date.beginning()
        if date.isFuture() && !countStyle.isFutureStyle() {
            countStyle = .futureDefault
        }
        else if !date.isFuture() && countStyle.isFutureStyle() {
            countStyle = .pastDefault
        }
    }

    var startDate: Date? {
        switch countStyle {
        case .progress(let from):
            return from
        case .countUp, .countDown:
            return nil
        }
    }
}
