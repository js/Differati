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
            HStack {
                dropZone
                    .dropDestination(
                        for: URL.self,
                        action: { items, _ in
                            handleDrop(items: items)
                        },
                        isTargeted: { isTargeted in

                        }
                    )
            }
            .padding()

            GroupBox {
                CommandLineInstallView()
            }
            .padding()

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

    private func handleDrop(items: [URL]) -> Bool {
        guard items.count >= 2 else { return false }
        let diff = DiffImage(oldImageFileUrl: items[0], newImageFileUrl: items[1])
        NSLog("Dropped items: \(items), valid? \(diff.validate())")
        if diff.validate() {
            openWindow(value: diff)
            return true
        } else {
            return false
        }
    }

    private var dropZone: some View {
        VStack(spacing: 12) {
            Text("Add Two Images To Compare Differences")
                .font(.headline)
            Text("Drop Files Here")
                .foregroundStyle(.secondary)
        }
        .padding()
        .multilineTextAlignment(.center)
        .frame(minWidth: 128, minHeight : 128)
        .aspectRatio(contentMode: .fit)
        .background {
            RoundedRectangle(cornerRadius: 22)
                .fill(Color(NSColor.secondarySystemFill))
                .stroke(Color.gray, style: .init(lineWidth: 2, dash: [6]))
        }
    }
}

#Preview {
    WelcomeView()
}
