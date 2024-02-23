//
//  SideBySideView.swift
//  Differati
//
//  Created by Johan Sørensen on 23/02/2024.
//

import SwiftUI

struct SideBySideView: View {
    let old = NSImage(named: "one")!
    let new = NSImage(named: "two")!

    var body: some View {
        HStack {
            VStack {
                Text("Old")
                    .foregroundStyle(Color.red)
                ImageView(nsImage: old)
                    .border(.red)
            }
            VStack {
                Text("New")
                    .foregroundStyle(Color.green)
                ImageView(nsImage: new)
                    .border(.green)
            }
        }
    }
}

#Preview {
    SideBySideView()
}
