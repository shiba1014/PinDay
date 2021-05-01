//
//  EventViewSize.swift
//  PinDay
//
//  Created by shiba on 2021/05/01.
//

import SwiftUI

enum EventViewSize: CaseIterable {
    case small
    case medium
    case fullscreen

    var description: String {
        switch self {
        case .small: return "Small"
        case .medium: return "Medium"
        case .fullscreen: return "Full Screen"
        }
    }

    var aspectRatio: CGFloat {
        switch self {
        case .small: return 1.0
        case .medium: return 1.77
        case .fullscreen: return 0.0
        }
    }
}
