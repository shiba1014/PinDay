//
//  CreateBackgroundView.swift
//  PinDay
//
//  Created by shiba on 2021/04/23.
//

import SwiftUI

struct CreateBackgroundView: View {

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                DayCounterView()
                    .aspectRatio(1, contentMode: .fit)
                    .padding(.horizontal, 50)
            }
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct CreateBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        CreateBackgroundView()
    }
}
