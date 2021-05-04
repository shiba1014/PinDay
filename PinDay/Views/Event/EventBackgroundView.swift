//
//  EventBackgroundView.swift
//  PinDay
//
//  Created by shiba on 2021/05/01.
//

import SwiftUI

struct EventBackgroundView: View {

    private static let radius: CGFloat = 24
    let style: Event.BackgroundStyle
    let size: EventViewSize

    var body: some View {

        buildBackgroundView()
            .clipShape(RoundedRectangle(cornerRadius: Self.radius, style: .continuous))
    }

    @ViewBuilder
    private func buildBackgroundView() -> some View {
        let gradientNode = LinearGradient(
            gradient: Gradient(
                stops: [
                    .init(color: .clear, location: 0.0),
                    .init(color: Color.black.opacity(0.5), location: 1.0)
                ]
            ),
            startPoint: .top,
            endPoint: .bottom
        )

        switch style {

        case .color(let color):
            Rectangle()
                .fill(Color(color))

        case .image(let image):
            switch size {
            case .small, .medium:
                Image(uiImage: image)
                    .resizable()
                    .fitToAspectRatio(size.aspectRatio)
                    .overlay(gradientNode)

            case .fullscreen:
                Rectangle()
                    .fill(Color.clear)
                    .background(
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    )
                    .overlay(gradientNode)
            }
        }
    }
}

struct EventBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        EventBackgroundView(style: .color(.gray), size: .small)
    }
}
