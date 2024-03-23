//
//  WelcomeView.swift
//  Differati
//
//  Created by Johan Sørensen on 24/02/2024.
//

import SwiftUI

struct WelcomeView: View {
    @Environment(\.openWindow) private var openWindow
    @State private var isDropZoneTargeted = false

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
                            isDropZoneTargeted = isTargeted
                        }
                    )
            }
            .padding()

            GroupBox {
                CommandLineInstallView()
            }
            .padding()
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
        .frame(minWidth: 252, minHeight : 252)
        .aspectRatio(contentMode: .fit)
        .background {
            RoundedRectangle(cornerRadius: 22)
                .fill(Color(isDropZoneTargeted ? NSColor.selectedControlColor : NSColor.secondarySystemFill))
                .stroke(
                    isDropZoneTargeted ? Color(NSColor.selectedContentBackgroundColor) : Color.gray,
                    style: .init(lineWidth: 2, dash: [6])
                )
        }
    }
}

#Preview {
    WelcomeView()
}
