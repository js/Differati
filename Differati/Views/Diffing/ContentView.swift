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

    @State private var isShowingOperationSheet = false

    enum Tab: String {
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

            StatusView(diff: diff)
        }
        .padding()
        .frame(minWidth: 700, minHeight: 400)
        .toolbar {
            ToolbarItem(id: "tabs", placement: .principal, showsByDefault: true) {
                HStack {
                    Picker("Tabs", selection: $selectedTab) {
                        Label("2-Up", systemImage: "platter.2.filled.ipad.landscape")
                            .tag(Tab.sideBySide)
                            .help("Show Side-by-Side View")
                        Label("Swipe", systemImage: "arrow.left.and.line.vertical.and.arrow.right")
                            .tag(Tab.swipe)
                            .help("Show Swipe View")
                        Label("Onion", systemImage: "square.2.layers.3d")
                            .tag(Tab.onion)
                            .help("Show Onion View")
                        Label("Difference", systemImage: "circlebadge.2")
                            .tag(Tab.diff)
                            .help("Show Difference View")
                    }
                    .pickerStyle(.segmented)
                    .labelStyle(.titleOnly)
                }
            }

            ToolbarItem(id: "spacer", placement: .principal, showsByDefault: true) {
                Spacer()
            }

            ToolbarItem(id: "replace", placement: .principal, showsByDefault: true) {
                Button {
                    isShowingOperationSheet.toggle()
                } label: {
                    Label("Replace Images", systemImage: "arrow.left.arrow.right")
                }
                .help("Replace Images With Each Other")
            }
        }
        .sheet(isPresented: $isShowingOperationSheet) {
           OperationsView(diff: diff)
        }
    }

    @ViewBuilder
    private var tabView: some View {
        switch selectedTab {
        case .sideBySide:
            SideBySideView(diff: diff)
                .tabItem {
                    Label("2-Up", systemImage: "platter.2.filled.ipad.landscape")
                }
                .tag(Tab.sideBySide)
        case .swipe:
            SwipeView(diff: diff)
                .tabItem {
                    Label("Swipe", systemImage: "arrow.left.and.line.vertical.and.arrow.right")
                }
                .tag(Tab.swipe)
        case .onion:
            OnionView(diff: diff)
                .tabItem {
                    Label("Onion", systemImage: "square.2.layers.3d")
                }
                .tag(Tab.onion)
        case .diff:
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
