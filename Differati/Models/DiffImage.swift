//
//  DiffImage.swift
//  Differati
//
//  Created by Johan Sørensen on 24/02/2024.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct DiffImage: Hashable, Codable {
    let oldImageFileUrl: URL
    let newImageFileUrl: URL

    func validate() -> Bool {
        FileManager.default.fileExists(atPath: oldImageFileUrl.path()) &&
        FileManager.default.fileExists(atPath: newImageFileUrl.path()) &&
        oldImageFileUrl.isImage &&
        newImageFileUrl.isImage
    }

    var oldImage: NSImage {
        NSImage(contentsOf: oldImageFileUrl)!
    }

    var newImage: NSImage {
        NSImage(contentsOf: newImageFileUrl)!
    }
}

private extension URL {
    var isImage: Bool {
        guard
            let resourceValues = try? resourceValues(forKeys: [.contentTypeKey]),
            let contentType = resourceValues.contentType
        else {
            return false
        }

        return contentType.conforms(to: UTType.image)
    }
}

extension DiffImage {
    static var preview: DiffImage {
        DiffImage(
            oldImageFileUrl: URL(fileURLWithPath: "/Users/johan/Desktop/differati/one.jpg"),
            newImageFileUrl: URL(fileURLWithPath: "/Users/johan/Desktop/differati/two.jpg")
        )
    }
}
