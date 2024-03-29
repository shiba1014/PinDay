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

    private let size: EventViewSize
    private let progress: CGFloat

    init(start: Date, end: Date, now: Date, size: EventViewSize) {
        self.size = size
        progress = CGFloat(Date.calcProgress(from: start, to: end, now: now))
    }

    var body: some View {
        HStack(spacing: size.spacing) {
            ZStack {
                Circle()
                    .stroke(lineWidth: size.lineWidth)
                    .opacity(0.3)
                    .foregroundColor(.white)

                Circle()
                    .trim(from: 0.0, to: progress)
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

            Text("\(Int(round(progress*100)))%")
                .font(size.bodyFont)
                .foregroundColor(.white)
        }
    }
}

struct CircularDayProgressView_Previews: PreviewProvider {
    static var previews: some View {
        return CircularDayProgressView(
            start: Calendar.gregorian.startOfDay(for: Calendar.gregorian.startOfYear(for: Date())),
            end: Calendar.gregorian.startOfDay(for: Calendar.gregorian.endOfYear(for: Date())),
            now: Date(),
            size: .fullscreen
        )
        .preferredColorScheme(.dark)
    }
}
