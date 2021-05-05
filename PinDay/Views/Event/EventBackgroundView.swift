//
//  EventBackgroundView.swift
//  PinDay
//
//  Created by shiba on 2021/05/01.
//

import SwiftUI

struct EventBackgroundView: View {

    private var size: EventViewSize
    private var color: Color?
    private var image: Image?

    init(color: Color?, image: Image?, size: EventViewSize) {
        self.color = color
        self.image = image
        self.size = size
    }

    init(draft: EventDraft, size: EventViewSize) {
        self.init(color: draft.color, image: draft.image, size: size)
    }

    private let radius: CGFloat = 24
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
            .fill(color ?? .clear)
            .background(
                image.map {
                    $0.resizable().aspectRatio(contentMode: .fill)
                }
            )
            .if(size != .fullscreen) {
                $0.aspectRatio(size.aspectRatio, contentMode: .fit)

            }
            .if(image != nil) {
                $0.overlay(gradientNode)
            }
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
    }
}

struct EventBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        EventBackgroundView(draft: .countdownMock, size: .small)
    }
}
