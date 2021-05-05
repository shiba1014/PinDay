//
//  EventDetailView.swift
//  PinDay
//
//  Created by shiba on 2021/05/01.
//

import SwiftUI

struct EventDetailView: View {

    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var entity: EventEntity
    @Binding var eventCreateType: EventCreateType?

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
            EventSummaryView(entity: entity, size: .fullscreen)
                .ignoresSafeArea()

            buildToolBar()
                .padding(8)
        }
    }

    private func buildToolBar() -> some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(12)
                    .frame(width: 44, height: 44)
                    .foregroundColor(.white)
            }

            Spacer()

            Button(action: {
                eventCreateType = .edit(entity: entity)
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "square.and.pencil")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(12)
                    .frame(width: 44, height: 44)
                    .foregroundColor(.white)
            }
        }
    }
}
