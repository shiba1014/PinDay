//
//  FilteredEventList.swift
//  PinDay
//
//  Created by shiba on 2021/05/06.
//

import SwiftUI

enum SortOption: Int, CaseIterable {
    case dateCreated
    case pinnedDate

    var description: String {
        switch self {
        case .dateCreated: return "Date Created"
        case .pinnedDate: return "Pinned Date"
        }
    }
}

// Ref: https://www.hackingwithswift.com/books/ios-swiftui/dynamically-filtering-fetchrequest-with-swiftui
struct FilteredEventList<Content: View>: View {
    private var fetchRequest: FetchRequest<Event>
    private let content: (Event) -> Content

    var body: some View {
        ForEach(fetchRequest.wrappedValue) { event in
            self.content(event)
        }
    }

    init(sortOption: SortOption, @ViewBuilder content: @escaping (Event) -> Content) {

        let descriptors: [NSSortDescriptor]
        switch sortOption {
        case .dateCreated:
            descriptors = [.init(keyPath: \Event.createdAt, ascending: true)]
        case .pinnedDate:
            descriptors = [.init(keyPath: \Event.pinnedDate, ascending: true)]
        }

        fetchRequest = FetchRequest<Event>(
            entity: Event.entity(),
            sortDescriptors: descriptors,
            animation: .default
        )
        self.content = content
    }
}
