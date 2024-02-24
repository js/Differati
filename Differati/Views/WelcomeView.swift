//
//  WelcomeView.swift
//  Differati
//
//  Created by Johan Sørensen on 24/02/2024.
//

import SwiftUI

struct WelcomeView: View {
    @Environment(\.openWindow) private var openWindow

    var body: some View {
        VStack {
            Button("Install command line tool") {}

            Button("Test Diff") {
                let diff = DiffImage(
                    oldImageFileUrl: URL(fileURLWithPath: "/Users/johan/Desktop/differati/one.jpg"),
                    newImageFileUrl: URL(fileURLWithPath: "/Users/johan/Desktop/differati/two.jpg")
                )
                openWindow(value: diff)
            }
        }
        .padding()
    }
}

#Preview {
    WelcomeView()
}
