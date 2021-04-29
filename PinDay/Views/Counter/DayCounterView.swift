//
//  DayCounterView.swift
//  PinDay
//
//  Created by Satsuki Hashiba on 2021/04/11.
//

import SwiftUI

struct DayCounterView: View {
    private static let radius: CGFloat = 24

    @ObservedObject var event: NewEvent

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .bottom)) {

            BackgroundView(style: event.backgroundStyle)

            VStack(alignment: .leading, spacing: 8) {
                Text(event.title)
                    .font(Font.title2.weight(.medium))
                Text("37 days left")
                    .font(.body)
            }
            .padding(.all, 20)

        }
    }

    static let mock: DayCounterView = {
        DayCounterView(event: .mock)
    }()
}

struct DayCounterView_Previews: PreviewProvider {
    static var previews: some View {
        DayCounterView.mock
    }
}

struct BackgroundView: View {
    private static let radius: CGFloat = 24
    var style: NewEvent.BackgroundStyle

    var body: some View {
        switch style {
        case .color(let color):
            RoundedRectangle(cornerRadius: Self.radius)
                .fill(color)
        case .image(let image):
            image
                .fitToAspectRatio(1)
                .clipShape(RoundedRectangle(cornerRadius: Self.radius))
        }
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView(style: .color(.gray))
    }
}
