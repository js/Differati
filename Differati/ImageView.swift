//
//  ImageView.swift
//  Differati
//
//  Created by Johan Sørensen on 23/02/2024.
//

import SwiftUI

struct ImageView: View {
    let image: Image

    init(_ image: Image) {
        self.image = image
    }

    init(nsImage: NSImage) {
        self.image = Image(nsImage: nsImage)
    }

    init(cgImage: CGImage) {
        let nsImage = NSImage(
            cgImage: cgImage,
            size: NSSize(width: cgImage.width, height: cgImage.height)
        )
        self.image = Image(nsImage: nsImage)
    }

    var body: some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

#Preview {
    ImageView(nsImage: NSImage(named: "one")!)
}
