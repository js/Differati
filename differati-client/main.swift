//
//  main.swift
//  differati-client
//
//  Created by Johan Sørensen on 24/02/2024.
//

import Foundation
import Cocoa

guard CommandLine.arguments.count == 3 else {
    print("Usage: differati <old-image> <new-image>")
    exit(2)
}

func stdErrorPrint(_ msg: String) {
    class StandardError: TextOutputStream {
        func write(_ string: String) {
            try! FileHandle.standardError.write(contentsOf: Data(string.utf8))
        }
    }

    var standardError = StandardError()
    print(msg, to: &standardError)
}

let client = CommandClient()
let mainAppBundleId = "com.frosthaus.Differati"
if client.connect(port: mainAppBundleId) == false {
    guard let appUrl = NSWorkspace.shared.urlForApplication(withBundleIdentifier: mainAppBundleId) else {
        stdErrorPrint("Unable to find main Differati application")
        exit(1)
    }

    NSWorkspace.shared.openApplication(at: appUrl, configuration: .init()) { app, error in
        if let error {
            stdErrorPrint("Unable to open main Differati application: \(error)")
            exit(1)
        }
    }

    usleep(450_000)
    
    // try connecting again now that main app should be running
    guard client.connect(port: mainAppBundleId) else {
        stdErrorPrint("Unable to connect to main Differati application. Is it running?")
        exit(1)
    }
}

let verbose = ProcessInfo.processInfo.environment["DIFFERATI_VERBOSE"] != nil

func log(_ msg: String) {
    if verbose {
        NSLog(msg)
    }
}

// 0 is name of executable
let old = CommandLine.arguments[1]
let new = CommandLine.arguments[2]

log("Diffing \(old) -> \(new)")

switch client.sendCommand("\(old)\n\(new)") {
case .success(let response):
    log("Server said: \(response)")
case .failure(let error):
    stdErrorPrint("Communication error \(error)")
    exit(2)
}

log("Done")
