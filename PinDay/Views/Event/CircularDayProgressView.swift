//
//  CircularDayProgressView.swift
//  PinDay
//
//  Created by shiba on 2021/05/01.
//

import SwiftUI

fileprivate extension EventViewSize {

    var spacing: CGFloat {
        switch self {
        case .small, .medium: return 12
        case .fullscreen: return 20
        }
    }

    var lineWidth: CGFloat {
        switch self {
        case .small, .medium: return 7
        case .fullscreen: return 10
        }
    }

    var square: CGFloat {
        switch self {
        case .small, .medium: return 40
        case .fullscreen: return 60
        }
    }
}

struct CircularDayProgressView: View {

    let start: Date
    let end: Date
    let size: EventViewSize

    private let timer = Timer.publish(every: 3600, on: .current, in: .common).autoconnect()

    @State private var progress: Float

    init(start: Date, end: Date, size: EventViewSize) {
        self.start = start
        self.end = end
        self.size = size
        _progress = State<Float>(initialValue: Date.calcProgress(from: start, to: end))
    }

    var body: some View {
        HStack(spacing: size.spacing) {
            ZStack {
                Circle()
                    .stroke(lineWidth: size.lineWidth)
                    .opacity(0.3)
                    .foregroundColor(.white)

                Circle()
                    .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                    .stroke(
                        style: .init(
                            lineWidth: size.lineWidth,
                            lineCap: .round,
                            lineJoin: .round
                        )
                    )
                    .foregroundColor(.white)
                    .rotationEffect(Angle(degrees: 270.0))
            }
            .frame(width: size.square, height: size.square)

            Text("\(Int(progress*100))%")
                .font(size.bodyFont)
                .foregroundColor(.white)

        }
        .onReceive(timer) { _ in
            progress = Date.calcProgress(from: start, to: end)
        }
    }
}

struct CircularDayProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircularDayProgressView(
            start: Date().fixed(month: 1, day: 1),
            end: Date().fixed(month: 12, day: 31),
            size: .fullscreen
        )
        .preferredColorScheme(.dark)
    }
}
