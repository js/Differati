//
//  ContentView.swift
//  Differati
//
//  Created by Johan Sørensen on 23/02/2024.
//

import SwiftUI

struct ContentView: View {
    let diff: DiffImage
    @Binding var selectedTab: Tab

    enum Tab: Hashable {
        case sideBySide
        case swipe
        case onion
        case diff
    }

    var body: some View {
        VStack {
            if diff.validate() {
                tabView
            } else {
                ContentUnavailableView(
                    "Image doesn't exist",
                    systemImage: "exclamationmark.triangle",
                    description: Text("One of the images doesn't exist")
                )
            }

            OperationsView(diff: diff)
        }
        .padding()
        .frame(minWidth: 700, minHeight: 400)
    }

    private var tabView: some View {
        TabView(selection: $selectedTab) {
            SideBySideView(diff: diff)
                .tabItem {
                    Label("2-Up", systemImage: "platter.2.filled.ipad.landscape")
                }
                .tag(Tab.sideBySide)
            SwipeView(diff: diff)
                .tabItem {
                    Label("Swipe", systemImage: "arrow.left.and.line.vertical.and.arrow.right")
                }
                .tag(Tab.swipe)
            OnionView(diff: diff)
                .tabItem {
                    Label("Onion", systemImage: "square.2.layers.3d")
                }
                .tag(Tab.onion)
            DifferenceView(diff: diff)
                .tabItem {
                    Label("Difference", systemImage: "circlebadge.2")
                }
                .tag(Tab.diff)
        }
    }
}

#Preview {
    ContentView(diff: .preview, selectedTab: .constant(.swipe))
}
