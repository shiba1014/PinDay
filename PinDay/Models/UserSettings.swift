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
