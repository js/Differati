//
//  CommandLineTool.swift
//  Differati
//
//  Created by Johan Sørensen on 25/02/2024.
//

import Foundation
import Cocoa

final class CommandLineTool {
    static let shared = CommandLineTool()
    let destination = "/usr/local/bin/differati"

    enum CommandLineToolError: Error {
        case notInstalled
        /// The tool could not be found in the app bundle
        case missingSoruceTool
    }

    var isInstalled: Bool {
        FileManager.default.fileExists(atPath: destination)
    }

    func currentVersion() throws -> String {
        throw CommandLineToolError.notInstalled
    }

    func install() async throws {
        guard let toolUrl = Bundle.main.resourceURL?.appending(path: "differati-client") else {
            NSLog("Failed to get URL to shell command")
            throw CommandLineToolError.missingSoruceTool
        }

        appleScriptShellInstallation(commandPath: toolUrl.path, destinationPath: destination)
    }

    private func appleScriptShellInstallation(commandPath: String, destinationPath: String) {
        let msg = "Create \(destinationPath) symbolic link"

        let script = if isInstalled {
            "mkdir -p /usr/local/bin && rm \'\(destinationPath)\' && ln -sf \'\(commandPath)\' \'\(destinationPath)\'"
        } else {
            "mkdir -p /usr/local/bin && ln -sf \'\(commandPath)\' \'\(destinationPath)\'"
        }

        // AuthorizationExecuteWithPrivileges is deprecated since forever and NSWorkspace.shared.requestAuthorization
        // seems to oonly work for sandboxed apps (? not working for me anyway).
        // Use osascript to get auth instead, cargo culted from https://github.com/CodeEditApp/CodeEdit/pull/667
        let cmdStr = [
            "osascript",
            "-e",
            "\"do shell script \\\"\(script)\\\"",
            "with prompt \\\"\(msg)\\\" with administrator privileges\""
        ].joined(separator: " ")

        do {
            let output = try execute(command: cmdStr)
            NSLog("osascript ran with output: \(output ?? "(nil)")")
        } catch {
            NSLog("fallback shell install error: \(error)")
        }
    }

    private func execute(command: String) throws -> String? {
        let task = Process()
        let pipe = Pipe()

        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.executableURL = URL(fileURLWithPath: "/bin/zsh")
        task.standardInput = nil

        try task.run()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: .utf8)
    }
}
