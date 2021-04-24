//
//  SelectColorView.swift
//  PinDay
//
//  Created by shiba on 2021/04/24.
//

import SwiftUI

struct SelectColorView: View {
    private let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple, .pink, .gray, .black]
    @Binding var selectedColor: Color?

    var body: some View {
        LazyVGrid(columns: [GridItem(), GridItem(), GridItem(), GridItem(), GridItem(), GridItem()], spacing: 8) {
            ForEach(colors, id: \.self) { color in
                Circle()
                    .foregroundColor(color)
                    .aspectRatio(contentMode: .fit)
                    .padding(5)
                    .overlay(
                        Circle().stroke(
                            color == selectedColor ? Color(UIColor.systemFill) : .clear,
                            lineWidth: 3
                        )
                    )
                    .onTapGesture {
                        selectedColor = color
                    }
            }
        }
    }
}

struct SelectColorView_Previews: PreviewProvider {
    static var previews: some View {
        SelectColorView(selectedColor: .constant(nil))
    }
}
