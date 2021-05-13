//
//  CountStyle.swift
//  PinDay
//
//  Created by shiba on 2021/05/13.
//

import Foundation

enum CountStyle: String, CaseIterable {
    case countUp
    case countDown
    case progress

    var description: String {
        switch self {
        case .countUp: return "Count Up"
        case .countDown: return "Count Down"
        case .progress: return "Progress"
        }
    }

    var preview: EventSummaryView {
        switch self {
        case .countUp: return EventSummaryView(draft: .pastMock, size: .small)
        case .countDown: return EventSummaryView(draft: .countdownMock, size: .small)
        case .progress: return EventSummaryView(draft: .progressMock, size: .small)
        }
    }
}
