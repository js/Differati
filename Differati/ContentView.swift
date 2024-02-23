//
//  ContentView.swift
//  Differati
//
//  Created by Johan Sørensen on 23/02/2024.
//

import SwiftUI

struct ContentView: View {
    @Binding var selectedTab: Tab

    enum Tab: Hashable {
        case sideBySide
        case swipe
        case onion
        case diff
    }

    var body: some View {
        VStack {
            TabView(selection: $selectedTab) {
                SideBySideView()
                    .tabItem {
                        Label("Side by Side", systemImage: "platter.2.filled.ipad.landscape")
                    }
                    .tag(Tab.sideBySide)
                SwipeView()
                    .tabItem {
                        Label("Swipe", systemImage: "arrow.left.and.line.vertical.and.arrow.right")
                    }
                    .tag(Tab.swipe)
                OnionView()
                    .tabItem {
                        Label("Onion", systemImage: "square.2.layers.3d")
                    }
                    .tag(Tab.onion)
                DifferenceView()
                    .tabItem {
                        Label("Difference", systemImage: "circlebadge.2")
                    }
                    .tag(Tab.diff)
            }

//            Button("Overwrite old with new") {
//
//            }
        }
        .padding()    }
}

#Preview {
    ContentView(selectedTab: .constant(.swipe))
}
