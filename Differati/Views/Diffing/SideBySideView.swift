//
//  SideBySideView.swift
//  Differati
//
//  Created by Johan Sørensen on 23/02/2024.
//

import SwiftUI

struct SideBySideView: View {
    let diff: DiffImage

    var body: some View {
        HStack {
            VStack(spacing: 6) {
                Text("Old")
                    .foregroundStyle(Color.red)
                ImageView(nsImage: diff.oldImage)
                    .border(.red)
            }

            VStack(spacing: 6) {
                Text("New")
                    .foregroundStyle(Color.green)
                ImageView(nsImage: diff.newImage)
                    .border(.green)
            }
        }
    }
}

#Preview {
    SideBySideView(diff: .preview)
}
