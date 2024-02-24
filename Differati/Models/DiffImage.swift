//
//  DiffImage.swift
//  Differati
//
//  Created by Johan Sørensen on 24/02/2024.
//

import Foundation
import SwiftUI

struct DiffImage: Hashable, Codable {
    let oldImageFileUrl: URL
    let newImageFileUrl: URL

    func validate() -> Bool {
        // TODO: check if old + new still exist
        true
    }

    var oldImage: NSImage {
        NSImage(contentsOf: oldImageFileUrl)!
    }

    var newImage: NSImage {
        NSImage(contentsOf: newImageFileUrl)!
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
