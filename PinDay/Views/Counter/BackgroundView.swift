//
//  ThumbnailView.swift
//  PinDay
//
//  Created by shiba on 2021/04/24.
//

import SwiftUI

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
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(RoundedRectangle(cornerRadius: Self.radius))
        }
    }
}

struct ThumbnailView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView(style: .constant(.color(.gray)))
    }
}
