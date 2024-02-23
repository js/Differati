//
//  ContentView.swift
//  Differati
//
//  Created by Johan Sørensen on 23/02/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            TabView {
                SideBySideView()
                    .tabItem {
                        Label("Side by Side", systemImage: "platter.2.filled.ipad.landscape")
                    }
                OnionView()
                    .tabItem {
                        Label("Onion", systemImage: "square.2.layers.3d")
                    }
                DifferenceView()
                    .tabItem {
                        Label("Difference", systemImage: "circlebadge.2")
                    }
            }

//            Button("Overwrite old with new") {
//                
//            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
