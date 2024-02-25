//
//  OperationsView.swift
//  Differati
//
//  Created by Johan Sørensen on 25/02/2024.
//

import SwiftUI

struct OperationsView: View {
    let diff: DiffImage
    @AppStorage("isOperationsExpanded") private var isExpanded = false
    @State private var confirmingOverwriteOldWithNew = false
    @State private var confirmingOverwriteNewWithOld = false

    enum CopyOperation: Hashable {
        case overwriteOldWithNew
        case overwriteNewWithOld
    }

    var body: some View {
        DisclosureGroup("Operations", isExpanded: $isExpanded) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Old Image")
                        .font(.headline)
                        .foregroundStyle(Color.red)
                    Text(verbatim: diff.oldImageFileUrl.path)
                        .truncationMode(.middle)
                        .font(.callout)
                        .padding(.bottom, 4)
                    Button {
                        confirmingOverwriteOldWithNew = true
                    } label: {
                        Text("Replace old with new")
                    }
                    Button("Reveal in Finder") {
                        reveal(url: diff.oldImageFileUrl)
                    }
                }

                Spacer()
                Divider()
                Spacer()

                VStack(alignment: .trailing) {
                    Text("New Image")
                        .font(.headline)
                        .foregroundStyle(Color.green)
                    Text(verbatim: diff.newImageFileUrl.path)
                        .truncationMode(.middle)
                        .font(.callout)
                        .padding(.bottom, 4)
                    Button {
                        confirmingOverwriteNewWithOld = true
                    } label: {
                        Text("Replace new with old")
                    }
                    Button("Reveal in Finder") {
                        reveal(url: diff.newImageFileUrl)
                    }
                }
            }
            .padding()
        }
        .confirmationDialog("Replace old image with new image?", isPresented: $confirmingOverwriteOldWithNew) {
            Button("Replace", role: .destructive) {
                copy(source: diff.newImageFileUrl, destination: diff.oldImageFileUrl)
            }
        } message: {
            Text("This will replace \(diff.oldImageFileUrl.path()) and cannot be undone")
        }
        .confirmationDialog("Replace new image with old image?", isPresented: $confirmingOverwriteNewWithOld) {
            Button("Replace", role: .destructive) {
                copy(source: diff.oldImageFileUrl, destination: diff.newImageFileUrl)
            }
        } message: {
            Text("This will replace \(diff.newImageFileUrl.path()) and cannot be undone")
        }
    }

    private func copy(source: URL, destination: URL) {
        do {
            try FileManager.default.copyItem(at: source, to: destination)
        } catch {
            NSLog("failed to copy \(source) to \(destination)")
        }
    }

    private func reveal(url: URL) {
        NSWorkspace.shared.activateFileViewerSelecting([url])
    }
}

#Preview {
    OperationsView(diff: .preview)
}
