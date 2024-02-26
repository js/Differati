//
//  StatusView.swift
//  Differati
//
//  Created by Johan Sørensen on 26/02/2024.
//

import SwiftUI

struct StatusView: View {
    let diff: DiffImage

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Old Image")
                    .font(.headline)
                    .foregroundStyle(Color.red)
                Text(verbatim: diff.oldImageFileUrl.path)
                    .truncationMode(.middle)
                    .font(.callout)
                    .padding(.bottom, 4)
                    .lineLimit(1)
                Button("Reveal in Finder") {
                    reveal(url: diff.oldImageFileUrl)
                }
            }

            Spacer()

            VStack(alignment: .trailing) {
                Text("New Image")
                    .font(.headline)
                    .foregroundStyle(Color.green)
                Text(verbatim: diff.newImageFileUrl.path)
                    .truncationMode(.middle)
                    .font(.callout)
                    .padding(.bottom, 4)
                    .lineLimit(1)
                Button("Reveal in Finder") {
                    reveal(url: diff.newImageFileUrl)
                }
            }
        }
        .padding(.horizontal)
    }

    private func reveal(url: URL) {
        NSWorkspace.shared.activateFileViewerSelecting([url])
    }
}

#Preview {
    StatusView(diff: .preview)
}
