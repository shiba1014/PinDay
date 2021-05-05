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

    private let gradientNode = LinearGradient(
        gradient: Gradient(
            stops: [
                .init(color: .clear, location: 0.0),
                .init(color: Color.black.opacity(0.5), location: 1.0)
            ]
        ),
        startPoint: .top,
        endPoint: .bottom
    )

    var body: some View {
        Rectangle()
            .fill(style.color)
            .background(
                style.image.map {
                    $0.resizable().aspectRatio(contentMode: .fill)
                }
            )
            .if(size != .fullscreen) {
                $0.aspectRatio(size.aspectRatio, contentMode: .fit)

            }
            .if(style.image != nil) {
                $0.overlay(gradientNode)
            }
            .clipShape(RoundedRectangle(cornerRadius: Self.radius, style: .continuous))
    }
}

struct EventBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        EventBackgroundView(style: .color(.gray), size: .small)
    }
}
