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
        HStack {
            VStack {
                Spacer()
                IconView()
                Spacer()
            }
            .frame(width: 460)
            Divider()
                .padding(.bottom)
            VStack {
                DropZoneView()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                GroupBox {
                    CommandLineInstallView()
                }
                .padding()
            }
            .frame(width: 320)
        }
    }
}

#Preview {
    WelcomeView()
}
