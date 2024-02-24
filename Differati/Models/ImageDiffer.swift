//
//  ImageDiffer.swift
//  Differati
//
//  Created by Johan Sørensen on 24/02/2024.
//

import Foundation
import SwiftUI

extension NSImage {
    var cgImage: CGImage? {
        var rect = NSRect(origin: CGPoint(x: 0, y: 0), size: self.size)
        return cgImage(forProposedRect: &rect, context: .current, hints: nil)
    }
}

extension CIImage {
    func cgImage(context: CIContext? = nil) -> CGImage? {
        let ctx = context ?? CIContext(options: nil)
        return ctx.createCGImage(self, from: extent)
    }
}

//    /// Create an NSImage version of this image
//    /// - Parameters:
//    ///   - pixelSize: The number of pixels in the result image. For a retina image (for example), pixelSize is double repSize
//    ///   - repSize: The number of points in the result image
//    /// - Returns: Converted image, or nil
//#if os(macOS)
//    @available(macOS 10, *)
//    func asNSImage(pixelsSize: CGSize? = nil, repSize: CGSize? = nil) -> NSImage? {
//        let rep = NSCIImageRep(ciImage: self)
//        if let ps = pixelsSize {
//            rep.pixelsWide = Int(ps.width)
//            rep.pixelsHigh = Int(ps.height)
//        }
//        if let rs = repSize {
//            rep.size = rs
//        }
//        let updateImage = NSImage(size: rep.size)
//        updateImage.addRepresentation(rep)
//        return updateImage
//    }
//#endif
//}

final class ImageDiffer {
    let oldImage: NSImage
    let newImage: NSImage

    init(oldImage: NSImage, newImage: NSImage) {
        self.oldImage = oldImage
        self.newImage = newImage
    }

    enum DifferenceError: Error {
        case conversionError
        case failedToCreateFilter
        case noOutput
        case outputConversionError
    }

    func difference(usingThreshold: Bool) throws -> CGImage {
        guard
            let old = oldImage.cgImage.flatMap(CIImage.init(cgImage:)),
            let new = newImage.cgImage.flatMap(CIImage.init(cgImage:)) else {
            throw DifferenceError.conversionError
        }

        let diffed: CIImage = if usingThreshold {
            try thresholdDifference(old: old, new: new)
        } else {
            try basicDifference(old: old, new: new)
        }

        guard let cgImage = diffed.cgImage() else {
            throw DifferenceError.conversionError
        }
        return cgImage
    }

    private func thresholdDifference(old: CIImage, new: CIImage) throws -> CIImage {
        // Calculate the differences between the two images
        let differenceImage = new
            .applyingFilter("CIDifferenceBlendMode", parameters: [kCIInputBackgroundImageKey: old])

        // Apply a threshold to emphasize significant differences
        let threshold: CGFloat = 0.1
        let thresholdedImage = differenceImage
            .applyingFilter("CIColorThreshold", parameters: ["inputThreshold": threshold])

        // Convert the differences to a visible color (e.g., red)
        let highlightedImage = thresholdedImage
            .applyingFilter("CIFalseColor", parameters: [
                "inputColor0": CIColor(red: 0, green: 0, blue: 0, alpha: 1),
                "inputColor1": CIColor(red: 1, green: 0, blue: 0, alpha: 1),
            ])

        // Composite the colored differences over one of the original images
        let diffed = highlightedImage
            .composited(over: old)

        return diffed
    }

    private func basicDifference(old: CIImage, new: CIImage) throws -> CIImage {
        guard let diffFilter = CIFilter(name: "CIDifferenceBlendMode") else {
            throw DifferenceError.failedToCreateFilter
        }
        diffFilter.setDefaults()

        // Center the new image in the old image
        let centerTransform = CGAffineTransform(
            translationX: old.extent.midX - (new.extent.size.width / 2),
            y: old.extent.midY - (new.extent.size.height / 2)
        )
        diffFilter.setValue(new.transformed(by: centerTransform), forKey: "inputImage")

        diffFilter.setValue(old, forKey: kCIInputImageKey)
        diffFilter.setValue(new, forKey: kCIInputBackgroundImageKey)

        guard let diffed = diffFilter.outputImage else {
            throw DifferenceError.noOutput
        }

        return diffed
    }
}
