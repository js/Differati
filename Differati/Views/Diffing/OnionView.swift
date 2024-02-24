//
//  OnionView.swift
//  Differati
//
//  Created by Johan Sørensen on 23/02/2024.
//

import SwiftUI

struct OnionView: View {
    let diff: DiffImage

    @State private var opacity = 1.0

    var body: some View {
        VStack {
            ZStack {
                ImageView(nsImage: diff.oldImage)
                    .border(.red)
                ImageView(nsImage: diff.newImage)
                    .border(.green)
                    .opacity(opacity)
            }

            Slider(value: $opacity, in: 0...1) {
                Text("Opacity")
            }
            .frame(maxWidth: 400)
        }
    }
}

#Preview {
    OnionView(diff: .preview)
}
