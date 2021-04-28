//
//  DayCounterView.swift
//  PinDay
//
//  Created by Satsuki Hashiba on 2021/04/11.
//

import SwiftUI

struct DayCounterView: View {

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .bottom)) {

            BackgroundView(style: .constant(.color(.gray)))

            VStack(alignment: .leading, spacing: 8) {
                Text("Xmas")
                    .font(Font.title2.weight(.medium))
                Text("37 days left")
                    .font(.body)
            }
            .padding(.all, 20)

        }
    }

    static let mock: DayCounterView = {
        DayCounterView(event: .constant(.mock))
    }()
}

struct DayCounterView_Previews: PreviewProvider {
    static var previews: some View {
        DayCounterView.mock
    }
}

struct BackgroundView: View {
    private static let radius: CGFloat = 24
    @Binding var style: NewEvent.BackgroundStyle

    var body: some View {
        if case .color(let color) = style {
            RoundedRectangle(cornerRadius: Self.radius)
                .fill(color)
        }
        else if case .image(let image) = style {
            image
                .fitToAspectRatio(1)
                .clipShape(RoundedRectangle(cornerRadius: Self.radius))
        }
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView(style: .constant(.color(.gray)))
    }
}
