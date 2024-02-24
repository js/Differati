//
//  CommandServer.swift
//  Differati
//
//  Created by Johan Sørensen on 24/02/2024.
//

import Foundation

final class CommandServer {
    var onReceive: (String) -> String? = { _ in nil }

    private let portName: CFString = Bundle.main.bundleIdentifier! as CFString
    private var messagePort: CFMessagePort?

    private lazy var callback: CFMessagePortCallBack = {msgPort, msgID, cfData, info in
        guard let serverPtr = info,
              let dataReceived = cfData as Data?,
              let string = String(data: dataReceived, encoding: .utf8) else {
            return nil
        }

        let server = Unmanaged<CommandServer>.fromOpaque(serverPtr).takeUnretainedValue()
       
        if let responseString = server.receive(string) {
            return Unmanaged.passRetained(Data(string.utf8) as CFData)
        } else { // send back default reply
            return Unmanaged.passRetained(Data("success".utf8) as CFData)
        }
    }

    deinit {
        stop()
    }

    func start(onReceive: @escaping (String) -> String?) {
        self.onReceive = onReceive

        guard messagePort == nil else {
            NSLog("Server already running for \(portName)!")
            return
        }

        let info = Unmanaged.passUnretained(self).toOpaque()
        var context = CFMessagePortContext(version: 0, info: info, retain: nil, release: nil, copyDescription: nil)

        if let messagePort = CFMessagePortCreateLocal(nil, portName, callback, &context, nil),
            let source = CFMessagePortCreateRunLoopSource(nil, messagePort, 0) {

            CFRunLoopAddSource(CFRunLoopGetMain(), source, .defaultMode)
            NSLog("\nStarted Command Server for: \(portName)")
            self.messagePort = messagePort
        }
    }

    func stop() {
        guard let messagePort else {
            NSLog("Not running, nothing to stop")
            return
        }

        CFMessagePortInvalidate(messagePort)
        self.messagePort = nil
    }

    private func receive(_ commandString: String) -> String? {
        NSLog("Received command string:\n\(commandString)")
        return onReceive(commandString)
    }
}
