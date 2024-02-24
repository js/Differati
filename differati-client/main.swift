//
//  main.swift
//  differati-client
//
//  Created by Johan Sørensen on 24/02/2024.
//

import Foundation

guard CommandLine.arguments.count == 3 else {
    print("Usage: differati <old-image> <new-image>")
    exit(2)
}

let client = CommandClient()

guard client.connect(port: "com.frosthaus.Differati") else {
    // TODO: launch with NSWorkspace
    print("Unable to connect to main Differati application. Is it running?")
    exit(1)
}

// 0 is name of executable
let old = CommandLine.arguments[1]
let new = CommandLine.arguments[2]

print("Diffing \(old) -> \(new)")

switch client.sendCommand("\(old)\n\(new)") {
case .success(let response):
    print("Server said: \(response)")
case .failure(let error):
    print(error)
    exit(2)
}

print("Done")
