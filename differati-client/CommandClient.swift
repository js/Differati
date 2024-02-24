//
//  CommandClient.swift
//  differati-client
//
//  Created by Johan Sørensen on 24/02/2024.
//

import Foundation

final class CommandClient {
    private var messagePort: CFMessagePort?

    func connect(port: String) -> Bool {
        guard let port = CFMessagePortCreateRemote(nil, port as CFString) else {
            return false
        }

        messagePort = port

        return true
    }

    enum ClientError: Error {
        case unknown
        case conversionError
    }

    func sendData(_ data: Data) -> Result<Data, ClientError> {
        var unmanagedData: Unmanaged<CFData>? = nil

        let status = CFMessagePortSendRequest(
            messagePort,
            0, // msg id
            data as CFData,
            3.0, 3.0, // send/recev timeout
            CFRunLoopMode.defaultMode.rawValue,
            &unmanagedData
        )
        let cfData = unmanagedData?.takeRetainedValue()
        if status == kCFMessagePortSuccess, let responseData = cfData as Data? {
            return .success(responseData)
        } else {
            return .failure(ClientError.unknown)
        }
    }

    func sendCommand(_ command: String) -> Result<String, ClientError> {
        sendData(Data(command.utf8)).flatMap { responseData in
            if let responseString = String(data: responseData, encoding: .utf8) {
                return .success(responseString)
            } else {
                return .failure(ClientError.conversionError)
            }
        }
    }
}
