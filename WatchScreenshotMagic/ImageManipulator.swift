//
//  ImageManipulator.swift
//  WatchScreenshotGenerator
//
//  Created by Nathan Trapp on 4/10/15.
//  Copyright (c) 2015 Trapp Design. All rights reserved.
//

import Cocoa

class ImageManipulator {
    class func glanceScreenshot(simulatorScreenshot: NSImage) -> NSImage {
        assert(CGSizeEqualToSize(simulatorScreenshot.size, CGSizeMake(312, 390)), "Invalid screenshot provided, must be 312x390 simulator screenshot")

        let glanceBackground = NSImage(named: "butterfly-with-pager")!

        // Remove the screenshots black background using a chroma key mask
        let chromaKeyedImage = simulatorScreenshot.chromaKey(NSColor.blackColor())!

        // overlay the chroma keyed image on the blurred butterfly clock face, with pager
        return NSImage(size: simulatorScreenshot.size, flipped: false) { rect in
            glanceBackground.drawAtPoint(NSZeroPoint, fromRect: NSZeroRect, operation: .CompositeCopy, fraction: 1)
            chromaKeyedImage.drawAtPoint(NSZeroPoint, fromRect: NSZeroRect, operation: .CompositeSourceOver, fraction: 1)

            return true
        }
    }

    class func notificationScreenshot(simulatorScreenshot: NSImage) -> NSImage {
        assert(CGSizeEqualToSize(simulatorScreenshot.size, CGSizeMake(312, 390)), "Invalid screenshot provided, must be 312x390 simulator screenshot")

        let notificationBackground = NSImage(named: "butterfly")!
        let statusBarOverlay = NSImage(named: "status-bar-overlay")!

        // overlay the the screenshot on the background using a screen composition
        // this is probably not exactly right, but it gives a good approximation
        // of displaying the clock face behind the notification body
        // set clock to 10:09 and remove charging indicator
        return NSImage(size: simulatorScreenshot.size, flipped: false) { rect in
            notificationBackground.drawAtPoint(NSZeroPoint, fromRect: NSZeroRect, operation: .CompositeCopy, fraction: 1)
            simulatorScreenshot.drawAtPoint(NSZeroPoint, fromRect: NSZeroRect, operation: .CompositeScreen, fraction: 1)
            statusBarOverlay.drawAtPoint(NSZeroPoint, fromRect: NSZeroRect, operation: .CompositeSourceOver, fraction: 1)

            return true
        }
    }

    class func appScreenshot(simulatorScreenshot: NSImage) -> NSImage {
        assert(CGSizeEqualToSize(simulatorScreenshot.size, CGSizeMake(312, 390)), "Invalid screenshot provided, must be 312x390 simulator screenshot")

        let statusBarOverlay = NSImage(named: "status-bar-overlay")!

        // set clock to 10:09 and remove charging indicator
        return NSImage(size: simulatorScreenshot.size, flipped: false) { rect in
            simulatorScreenshot.drawAtPoint(NSZeroPoint, fromRect: NSZeroRect, operation: .CompositeCopy, fraction: 1)
            statusBarOverlay.drawAtPoint(NSZeroPoint, fromRect: NSZeroRect, operation: .CompositeSourceOver, fraction: 1)

            return true
        }
    }
}

extension NSImage {
    func chromaKey(color: NSColor) -> NSImage? {
        if let computedColor = color.colorUsingColorSpaceName(NSCalibratedRGBColorSpace) {
            let tiffData = self.TIFFRepresentation
            let imageSourceRef = CGImageSourceCreateWithData(tiffData!, nil)
            let imageRef = CGImageSourceCreateImageAtIndex(imageSourceRef!, 0, nil)

            let bitsPerComponent = CGImageGetBitsPerComponent(imageRef)
            let maxComponent = CGFloat(1 << bitsPerComponent) - 1
            let redValue = CGFloat(computedColor.redComponent * maxComponent)
            let greenValue = CGFloat(computedColor.greenComponent * maxComponent)
            let blueValue = CGFloat(computedColor.blueComponent * maxComponent)

            let colorMask = [redValue, redValue, greenValue, greenValue, blueValue, blueValue]
            let maskedImageRef = CGImageCreateWithMaskingColors(imageRef, colorMask)

            return NSImage(CGImage: maskedImageRef!, size: size)
        } else {
            NSException(name: "Invalid Color", reason: "Provided color must be valid in the RGB color space", userInfo: nil).raise()

            return nil
        }
    }
}
