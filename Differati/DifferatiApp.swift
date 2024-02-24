//
//  DifferatiApp.swift
//  Differati
//
//  Created by Johan Sørensen on 23/02/2024.
//

import SwiftUI

@main
struct DifferatiApp: App {
    @State private var selectedTab: ContentView.Tab = .sideBySide

    var body: some Scene {
        WindowGroup("Welcome") {
            WelcomeView()
        }

        WindowGroup("Image Diff", for: DiffImage.self) { $diff in
            if let diff {
                ContentView(diff: diff, selectedTab: $selectedTab)
            } else {
                ContentUnavailableView(
                    "Image error",
                    image: "exclamationmark.triangle",
                    description: Text("Got an empty binding")
                )
            }
        }
        .commandsRemoved()
        .commands {
            CommandGroup(before: .toolbar) {
                Button("Show Side by Side") { selectedTab = .sideBySide }
                    .keyboardShortcut("1", modifiers: .command)
                Button("Show Swipe") { selectedTab = .swipe }
                    .keyboardShortcut("2", modifiers: .command)
                Button("Show Onion") { selectedTab = .onion }
                    .keyboardShortcut("3", modifiers: .command)
                Button("Show Difference") { selectedTab = .diff }
                    .keyboardShortcut("4", modifiers: .command)
                Divider()
            }
        }
    }
}
