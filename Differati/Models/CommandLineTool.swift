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

    func currentVersion() throws -> String {
        throw CommandLineToolError.notInstalled
    }

    func _install() async throws {
        guard let toolUrl = Bundle.main.resourceURL?.appending(path: "differati-client") else {
            NSLog("Failed to get URL to shell command")
            throw CommandLineToolError.missingSoruceTool
        }

        let auth = try await NSWorkspace.shared.requestAuthorization(to: .createSymbolicLink)
        let authedFileManager = FileManager(authorization: auth)

        if authedFileManager.fileExists(atPath: destination) {
            try authedFileManager.removeItem(atPath: destination)
        }

        do {
            NSLog("Authed – will link \(toolUrl.path) <- \(destination)")
            // Does this ever work?
            try authedFileManager.createSymbolicLink(at: URL(filePath: destination), withDestinationURL: toolUrl)
        } catch {
            NSLog("Running fallback shell install because: \(error)")
            appleScriptShellInstallation(commandPath: toolUrl.path, destinationPath: destination)
        }
    }

    func install() async throws {
        guard let toolUrl = Bundle.main.resourceURL?.appending(path: "differati-client") else {
            NSLog("Failed to get URL to shell command")
            throw CommandLineToolError.missingSoruceTool
        }

        appleScriptShellInstallation(commandPath: toolUrl.path, destinationPath: destination)
    }

    func appleScriptShellInstallation(commandPath: String, destinationPath: String) {
        // from https://github.com/CodeEditApp/CodeEdit/pull/667
        let msg = "Create \(destinationPath) symbolic link"
        let cmd = [
            "osascript",
            "-e",
            "\"do shell script \\\"mkdir -p /usr/local/bin && rm \'\(destinationPath)\' && ln -sf \'\(commandPath)\' \'\(destinationPath)\'\\\"",
            "with prompt \\\"\(msg)\\\" with administrator privileges\""
        ]

        let cmdStr = cmd.joined(separator: " ")

        let task = Process()
        let pipe = Pipe()

        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", cmdStr]
        task.executableURL = URL(fileURLWithPath: "/bin/zsh")
        task.standardInput = nil

        do {
            try task.run()

            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: .utf8) ?? ""
            NSLog("osascript ran with output: \(output)")
        } catch {
            NSLog("fallback shell install error: \(error)")
        }
    }
}
