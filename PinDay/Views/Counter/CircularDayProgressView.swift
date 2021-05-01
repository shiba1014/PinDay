//
//  CircularDayProgressView.swift
//  PinDay
//
//  Created by shiba on 2021/05/01.
//

import SwiftUI

struct CircularDayProgressView: View {

    let start: Date
    let end: Date
    private let lineWidth: CGFloat = 5
    private let timer = Timer.publish(every: 3600, on: .current, in: .common).autoconnect()

    @State private var progress: Float

    init(start: Date, end: Date) {
        self.start = start
        self.end = end
        _progress = State<Float>(initialValue: Date.calcProgress(from: start, to: end))
    }


    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .stroke(lineWidth: lineWidth)
                    .opacity(0.3)
                    .foregroundColor(.white)

                Circle()
                    .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                    .stroke(
                        style: .init(
                            lineWidth: lineWidth,
                            lineCap: .round,
                            lineJoin: .round
                        )
                    )
                    .foregroundColor(.white)
                    .rotationEffect(Angle(degrees: 270.0))
            }
            .frame(width: 40, height: 40)

            Text("\(Int(progress*100))%")
                .font(.body)
                .foregroundColor(.white)

        }
        .onReceive(timer) { _ in
            progress = Date.calcProgress(from: start, to: end)
        }
    }
}

struct CircularProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircularDayProgressView(
            start: Date().fixed(month: 1, day: 1),
            end: Date().fixed(month: 12, day: 31)
        )
        .preferredColorScheme(.dark)
    }
}
