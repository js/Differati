//
//  DropZoneView.swift
//  Differati
//
//  Created by Johan Sørensen on 24/03/2024.
//

import SwiftUI

struct DropZoneView: View {
    @Environment(\.openWindow) private var openWindow
    @State private var isDropZoneTargeted = false

    var body: some View {
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

    private var dropZone: some View {
        VStack(spacing: 12) {
            Spacer()
            Text("Add Two Images To Compare Differences")
                .font(.headline)
            Text("Drop Files Here")
                .foregroundStyle(.secondary)
            Spacer()
        }
        .padding()
        .multilineTextAlignment(.center)
        .frame(minWidth: 252, minHeight : 252)
        .background {
            RoundedRectangle(cornerRadius: 22)
                .fill(Color(isDropZoneTargeted ? NSColor.selectedControlColor : NSColor.tertiarySystemFill))
                .stroke(
                    isDropZoneTargeted ? Color(NSColor.selectedContentBackgroundColor) : Color.gray,
                    style: .init(lineWidth: 2, dash: [6])
                )
        }
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
}

#Preview {
    DropZoneView()
}
