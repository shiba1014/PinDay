//
//  EventSummaryView.swift
//  PinDay
//
//  Created by Satsuki Hashiba on 2021/04/11.
//

import SwiftUI

struct EventSummaryView: View {
    private static let radius: CGFloat = 24

    @ObservedObject var event: Event
    let size: EventViewSize

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .bottom)) {

            EventBackgroundView(style: event.backgroundStyle)

            VStack(alignment: .leading, spacing: 8) {
                Text(event.title)
                    .font(Font.title2.weight(.medium))
                    .foregroundColor(.white)

                event.makeCounterView()
            }
            .padding(.all, 20)
        }
        .if(size != .fullscreen) {
            $0.aspectRatio(size.aspectRatio, contentMode: .fit)
        }
    }
}

struct EventSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        EventSummaryView(event: .countDownMock, size: .small)
            .padding()
    }
}
