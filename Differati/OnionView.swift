//
//  OnionView.swift
//  Differati
//
//  Created by Johan Sørensen on 23/02/2024.
//

import SwiftUI

struct OnionView: View {
    let old = NSImage(named: "one")!
    let new = NSImage(named: "two")!

    @State private var opacity = 1.0

    var body: some View {
        VStack {
            ZStack {
                ImageView(nsImage: old)
                    .border(.red)
                ImageView(nsImage: new)
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
    OnionView()
}
