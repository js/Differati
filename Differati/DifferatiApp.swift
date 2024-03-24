//
//  DifferatiApp.swift
//  Differati
//
//  Created by Johan Sørensen on 23/02/2024.
//

import SwiftUI

@main
struct DifferatiApp: App {
    @AppStorage("lastUsedTab") private var selectedTab: ContentView.Tab = .sideBySide
    @State private var server = CommandServer()
    @Environment(\.openWindow) private var openWindow

    @State private var isPresentingUrlOpenError = false
    @State private var urlOpenError: OpenURLError?

    private let welcomeWindowId = "welcome-window"

    var body: some Scene {
        WindowGroup("Welcome", id: welcomeWindowId) {
            WelcomeView()
                .onAppear {
                    hackyWindowStyle()
                }
                .task {
                    server.start {
                        handleMessage($0)
                    }
                }
                .onOpenURL { url in
                    handleOpenURL(url)
                }
                .alert(isPresented: $isPresentingUrlOpenError, error: urlOpenError) { error in
                    Button("OK") {}
                } message: { error in
                    Text(error.recoverySuggestion ?? "Try a valid differati url.")
                }
        }
        .defaultPosition(.center)
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)

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
        .defaultPosition(.center)
        .defaultSize(width: 800, height: 600)
        .windowToolbarStyle(.unified)
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

    private func hackyWindowStyle() {
        DispatchQueue.main.async {
            let window = NSApplication.shared.windows.first(where: {
                $0.identifier?.rawValue.hasPrefix(welcomeWindowId) ?? false
            })
            guard let window else {
                return
            }

            window.isMovableByWindowBackground = true
            window.standardWindowButton(.miniaturizeButton)?.isHidden = true
            window.standardWindowButton(.zoomButton)?.isHidden = true
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

        NSLog("Opening from remote \(diff)")
        openWindow(value: diff)

        return nil
    }

    struct OpenURLError: LocalizedError {
        var errorDescription: String? {
            "Could not open unknown or badly formed URL"
        }
    }

    private func handleOpenURL(_ url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return }

        guard components.host == "show" else {
            urlOpenError = OpenURLError()
            isPresentingUrlOpenError = true
            return
        }
        guard
            let oldPath = components.queryItems?.first(where: { $0.name == "old" })?.value,
            let newPath = components.queryItems?.first(where: { $0.name == "new" })?.value
        else {
            urlOpenError = OpenURLError()
            isPresentingUrlOpenError = true
            return
        }

        let oldFileUrl = URL(filePath: oldPath.removingPercentEncoding ?? oldPath)
        let newFileUrl = URL(filePath: newPath.removingPercentEncoding ?? oldPath)

        let diff = DiffImage(oldImageFileUrl: oldFileUrl, newImageFileUrl: newFileUrl)
        openWindow(value: diff)
    }
}
