//
//  Image+Ext.swift
//  PinDay
//
//  Created by shiba on 2021/04/27.
//

import SwiftUI

// Ref: https://gist.github.com/karigrooms/fdf435274f4403abd57b1ed533dcea53#file-swiftui-resize-image-and-maintain-aspect-ratio-swift

/// Fit an image to a certain aspect ratio while maintaining its aspect ratio
struct FitToAspectRatio: ViewModifier {

    private let aspectRatio: CGFloat

    public init(_ aspectRatio: CGFloat) {
        self.aspectRatio = aspectRatio
    }

    public func body(content: Content) -> some View {
        ZStack {
            Rectangle()
                .fill(Color(.clear))
                .aspectRatio(aspectRatio, contentMode: .fit)

            content
                .scaledToFill()
                .layoutPriority(-1)
        }
        .clipped()
    }
}

// Image extension that composes with the `.resizable()` modifier
extension Image {
    func fitToAspectRatio(_ aspectRatio: CGFloat) -> some View {
        self.resizable().modifier(FitToAspectRatio(aspectRatio))
    }
}
