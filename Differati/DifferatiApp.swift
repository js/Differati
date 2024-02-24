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
    @State private var server = CommandServer()
    @Environment(\.openWindow) private var openWindow

    var body: some Scene {
        WindowGroup("Welcome") {
            WelcomeView()
                .task {
                    server.start(onReceive: handleMessage)
                }
        }

        WindowGroup("Image Diff", for: DiffImage.self) { $diff in
            if let diff {
                ContentView(diff: diff, selectedTab: $selectedTab)
            } else {
                ContentUnavailableView(
                    "Image error",
                    systemImage: "exclamationmark.triangle",
                    description: Text("Got an empty binding")
                )
            }
        }
        .commandsRemoved()
        .commands {
            CommandGroup(before: .toolbar) {
                Button("Show 2-Up") { selectedTab = .sideBySide }
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

    private func handleMessage(_ message: String) -> String? {
        let pairs = message.split(separator: "\n").map(String.init)

        guard pairs.count == 2 else {
            return "unknown format"
        }

        let diff = DiffImage(
            oldImageFileUrl: URL(fileURLWithPath: pairs[0]),
            newImageFileUrl: URL(fileURLWithPath: pairs[1])
        )

        openWindow(value: diff)

        return nil
    }
}
