//
//  CommandLineInstallView.swift
//  Differati
//
//  Created by Johan Sørensen on 25/02/2024.
//

import SwiftUI

struct CommandLineInstallView: View {
    @State private var presentedError: CommandLineInstallError?
    @State private var isPresentingError = false
    @State private var isInstalled = false

    struct CommandLineInstallError: LocalizedError {
        let underlyingError: Error

        var errorDescription: String? {
            underlyingError.localizedDescription
        }

        var recoverySuggestion: String? {
            (underlyingError as? LocalizedError)?.recoverySuggestion
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "apple.terminal.fill")
                .font(.largeTitle)

            Text("Install ") +
            Text("differati").monospaced() +
            Text(" command-line tool\nto") +
            Text("/usr/local/differati").monospaced()

            if isInstalled {
                VStack {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(Color.green)
                        Text("Installed")
                    }
                    Button("Reinstall") {
                        installCommandLineTool()
                    }
                }
            } else {
                Button("Install") {
                    installCommandLineTool()
                }
            }
        }
        .padding()
        .task {
            await checkIfInstalled()
        }
        .alert(
            isPresented: $isPresentingError,
            error: presentedError
        ) { _ in
            Button("OK") {}
        } message: { error in
            Text(error.recoverySuggestion ?? "Try again later.")
        }
    }

    private func checkIfInstalled() async {
        isInstalled = CommandLineTool.shared.isInstalled
    }

    private func installCommandLineTool() {
        Task {
            do {
                try await CommandLineTool.shared.install()
                isInstalled = true
            } catch {
                NSLog("Error installing command line tool: \(error)")
                presentedError = CommandLineInstallError(underlyingError: error)
                isPresentingError = true
            }
        }
    }
}

#Preview {
    CommandLineInstallView()
}
