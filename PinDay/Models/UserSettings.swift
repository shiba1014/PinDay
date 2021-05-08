//
//  UserSettings.swift
//  PinDay
//
//  Created by shiba on 2021/05/06.
//

import Foundation

class UserSettings: ObservableObject {
    @Published var eventViewSize: EventViewSize {
        willSet {
            UserDefaults.standard.eventViewSize = newValue
        }
    }

    @Published var sortOption: SortOption {
        willSet {
            UserDefaults.standard.sortOption = newValue
        }
    }

    init() {
        self.eventViewSize = UserDefaults.standard.eventViewSize
        self.sortOption = UserDefaults.standard.sortOption
    }
}

extension UserDefaults {

    private enum Keys {
        static let eventViewSize = "eventViewSize"
        static let sortOption = "sortOption"
    }

    var eventViewSize: EventViewSize {
        get {
            let rawValue = integer(forKey: Keys.eventViewSize)
            return EventViewSize(rawValue: rawValue) ?? .small
        }
        set {
            set(newValue.rawValue, forKey: Keys.eventViewSize)
        }
    }

    var sortOption: SortOption {
        get {
            let rawValue = integer(forKey: Keys.sortOption)
            return SortOption(rawValue: rawValue) ?? .dateCreated
        }
        set {
            set(newValue.rawValue, forKey: Keys.sortOption)
        }
    }
}

enum SortOption: Int, CaseIterable {
    case dateCreated
    case pinnedDate

    var description: String {
        switch self {
        case .dateCreated: return "Date Created"
        case .pinnedDate: return "Pinned Date"
        }
    }

    func sort(_ e1: Event, _ e2: Event) -> Bool {
        switch self {
        case .dateCreated: return e1.createdAt < e2.createdAt
        case .pinnedDate: return e1.pinnedDate < e2.pinnedDate
        }
    }
}
