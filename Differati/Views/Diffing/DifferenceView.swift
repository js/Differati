//
//  DiffView.swift
//  Differati
//
//  Created by Johan Sørensen on 23/02/2024.
//

import SwiftUI

struct DifferenceView: View {
    let diff: DiffImage

    @State private var diffedImage: Image?
    @State private var opacity = 1.0
    @State private var usingThreshold = false

    var body: some View {
        VStack {
            ZStack {
                ImageView(nsImage: diff.oldImage)
                if let diffedImage {
                    ImageView(diffedImage)
                        .opacity(opacity)
                } else {
                    ProgressView()
                }
            }

            HStack {
                Slider(value: $opacity, in: 0...1) {
                    Text("Opacity")
                }
                .frame(maxWidth: 400)

                Toggle("Highlight", isOn: $usingThreshold)
                    .keyboardShortcut("h", modifiers: [.command, .shift])
            }
        }
        .task(id: usingThreshold) {
            let differ = ImageDiffer(oldImage: diff.oldImage, newImage: diff.newImage)
            if let cgImage = try? differ.difference(usingThreshold: usingThreshold) {
                let nsImage = NSImage(
                    cgImage: cgImage,
                    size: NSSize(width: cgImage.width, height: cgImage.height)
                )
                diffedImage = Image(nsImage: nsImage)
            }

        }
    }
}

#Preview {
    DifferenceView(diff: .preview)
}
