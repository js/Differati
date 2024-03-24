//
//  IconView.swift
//  Differati
//
//  Created by Johan Sørensen on 24/03/2024.
//

import SwiftUI

struct IconView: View {
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .frame(width: 164, height: 164)
            Text("Differati")
                .font(.largeTitle.bold())
                .fontDesign(.rounded)
            Text("Version \(versionNumber)")
                .foregroundStyle(.secondary)
        }
    }

    private var versionNumber: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }
}

#Preview {
    IconView()
}
