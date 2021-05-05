//
//  EventSummaryView.swift
//  PinDay
//
//  Created by Satsuki Hashiba on 2021/04/11.
//

import SwiftUI

fileprivate extension EventViewSize {
    var spacing: CGFloat {
        switch self {
        case .small, .medium: return 8
        case .fullscreen: return 16
        }
    }

    var padding: CGFloat {
        switch self {
        case .small, .medium: return 20
        case .fullscreen: return 40
        }
    }
}

struct EventSummaryView: View {
    private static let radius: CGFloat = 24

    @ObservedObject var event: Event
    let size: EventViewSize

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .bottom)) {

            EventBackgroundView(style: event.backgroundStyle, size: size)

            VStack(alignment: .leading, spacing: size.spacing) {
                Text(event.title)
                    .font(size.titleFont)
                    .foregroundColor(.white)

                event.makeCounterView(size: size)
            }
            .padding(size.padding)
        }
    }
}

struct EventSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        EventSummaryView(event: .countDownMock, size: .small)
            .padding()
    }
}

struct NewEventSummaryView: View {

    private static let radius: CGFloat = 24

    var entity: EventEntity
    @Binding var size: EventViewSize

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .bottom)) {
            NewBackgroundView(eventViewSize: $size, entity: entity)

            VStack(alignment: .leading, spacing: size.spacing) {
                Text(entity.title ?? "")
                    .font(size.titleFont)
                    .foregroundColor(.white)

                entity.buildContentView(size: size)
            }
            .padding(size.padding)
        }
    }
}
