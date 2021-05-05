//
//  EventCreateType.swift
//  PinDay
//
//  Created by shiba on 2021/05/03.
//

enum EventCreateType: Identifiable {
    case new
    case edit(event: Event)

    var id: Int {
        switch self {
        case .new: return 0
        case .edit: return 1
        }
    }
}

enum NewEventCreateType: Identifiable {
    case new
    case edit(entity: EventEntity)

    var id: Int {
        switch self {
        case .new: return 0
        case .edit: return 1
        }
    }
}
