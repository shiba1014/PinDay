//
//  CircularDayProgressView.swift
//  PinDay
//
//  Created by shiba on 2021/05/01.
//

import SwiftUI

struct CircularDayProgressView: View {

    private let lineWidth: CGFloat = 5

    @Binding var value: CGFloat

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: lineWidth)
                .opacity(0.3)
                .foregroundColor(.white)

            Circle()
                .trim(from: 0.0, to: min(value, 1.0))
                .stroke(
                    style: .init(
                        lineWidth: lineWidth,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
                .foregroundColor(.white)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)
        }
    }
}

struct CircularProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircularDayProgressView(value: .constant(0.73))
            .preferredColorScheme(.dark)
    }
}
