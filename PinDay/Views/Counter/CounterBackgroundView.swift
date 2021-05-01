//
//  CounterBackgroundView.swift
//  PinDay
//
//  Created by shiba on 2021/05/01.
//

import SwiftUI

struct CounterBackgroundView: View {
    private static let radius: CGFloat = 24
    var style: NewEvent.BackgroundStyle

    var body: some View {
        Group {
            switch style {
            case .color(let color):
                Rectangle()
                    .fill(color)
            case .image(let image):
                image
                    .fitToAspectRatio(1)
            }
        }
        .overlay(
            LinearGradient(
                gradient: Gradient(
                    stops: [
                        .init(color: .clear, location: 0.2),
                        .init(color: Color.black.opacity(0.5), location: 1.0)
                    ]
                ),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: Self.radius))
    }
}

struct CounterBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        CounterBackgroundView(style: .color(.gray))
    }
}
