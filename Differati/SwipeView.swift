//
//  SwipeView.swift
//  Differati
//
//  Created by Johan Sørensen on 23/02/2024.
//

import SwiftUI

struct SwipeView: View {
    let old = NSImage(named: "one")!
    let new = NSImage(named: "two")!

    @State private var percentage = 0.5

    var body: some View {
        VStack {
            ZStack {
                ImageView(nsImage: old)
                    .border(.red)
                ImageView(nsImage: new)
                    .border(.green)
                    .mask(alignment: .leading) {
                        GeometryReader { geo in
                            Color.black
                                .frame(width: geo.size.width * percentage)
                        }
                    }
                    .overlay(alignment: .leading) {
                        GeometryReader { geo in
                            Rectangle()
                                .fill(.white)
                                .opacity(0.05)
                                .frame(width: 1, height: geo.size.height)
                                .offset(x: geo.size.width * percentage)
                        }
                    }
            }

            Slider(value: $percentage, in: 0...1) {
                EmptyView()
            }
        }
    }
}

#Preview {
    SwipeView()
}
