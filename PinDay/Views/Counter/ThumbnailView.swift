//
//  ThumbnailView.swift
//  PinDay
//
//  Created by shiba on 2021/04/24.
//

import SwiftUI

struct ThumbnailView: View {
    @Binding var color: Color

    var body: some View {
        RoundedRectangle(cornerRadius: 24)
            .fill(color)

    }
}

struct ThumbnailView_Previews: PreviewProvider {
    static var previews: some View {
        ThumbnailView(color: .constant(.orange))
    }
}
