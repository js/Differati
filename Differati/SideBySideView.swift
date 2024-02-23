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
            ImageView(nsImage: old)
            ImageView(nsImage: new)
        }
    }
}

#Preview {
    SideBySideView()
}
