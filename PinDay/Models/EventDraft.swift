//
//  EventDraft.swift
//  PinDay
//
//  Created by shiba on 2021/05/05.
//

import SwiftUI

class EventDraft: ObservableObject {

    enum BackgroundStyle {
        case color(UIColor)
        case image(UIImage)

        var color: Color? {
            switch self {
            case .color(let color): return Color(color)
            case .image: return nil
            }
        }

        var image: Image? {
            switch self {
            case .color: return nil
            case .image(let image): return Image(uiImage: image)
            }
        }
    }

    static let maxTitleCount: Int = 15

    @Published var title: String
    @Published var pinnedDate: Date
    @Published var startDate: Date?
    @Published var backgroundStyle: BackgroundStyle

    var color: Color? {
        switch backgroundStyle {
        case .color(let color): return Color(color)
        case .image: return nil
        }
    }

    var image: Image? {
        switch backgroundStyle {
        case .color: return nil
        case .image(let image): return Image(uiImage: image)
        }
    }

    var isValid: Bool {
        !title.isEmpty && title.count <= Self.maxTitleCount
    }

    init(
        title: String = "",
        pinnedDate: Date = .init(),
        startDate: Date? = nil,
        backgroundStyle: BackgroundStyle = .color(.appGray)
    ) {
        self.title = title
        self.pinnedDate = pinnedDate
        self.startDate = startDate
        self.backgroundStyle = backgroundStyle
    }
}

// MARK: Mock
extension EventDraft {
    static let pastMock: EventDraft = {
        let date = Date().fixed(month: 1, day: 1).beginning()
        return EventDraft(
            title: "\(date.year)",
            pinnedDate: date,
            startDate: nil,
            backgroundStyle: .color(.appYellow)
        )
    }()

    static let countdownMock: EventDraft = {
        let date = Date().fixed(month: 1, day: 1).added(year: 1).beginning()
        return EventDraft(
            title: "New Year",
            pinnedDate: date,
            startDate: nil,
            backgroundStyle: .color(.appPurple)
        )
    }()

    static let progressMock: EventDraft = {
        let date = Date().fixed(month: 12, day: 31).beginning()
        let startDate = Date().fixed(month: 1, day: 1).beginning()
        return EventDraft(
            title: "\(date.year)",
            pinnedDate: date,
            startDate: startDate,
            backgroundStyle: .color(.appOrange)
        )
    }()
}

extension Event {
    func createDraft() -> EventDraft {

        let draft = EventDraft(
            title: title,
            pinnedDate: pinnedDate,
            startDate: startDate
        )

        if let colorData = backgroundColor,
           let uiColor = UIColor.decode(colorData) {
            draft.backgroundStyle = .color(uiColor)
        }

        if let imageData = backgroundImage,
           let uiImage = UIImage(data: imageData) {
            draft.backgroundStyle = .image(uiImage)
        }

        return draft
    }

    func override(with draft: EventDraft) {
        title = draft.title
        pinnedDate = draft.pinnedDate
        startDate = draft.startDate

        switch draft.backgroundStyle {
        case .color(let color):
            backgroundColor = Data.encode(color: color)
            backgroundImage = nil
        case .image(let image):
            backgroundColor = nil
            backgroundImage = Data.encode(image: image)
        }
    }
}
