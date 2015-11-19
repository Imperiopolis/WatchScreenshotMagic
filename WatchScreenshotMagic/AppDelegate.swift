//
//  AppDelegate.swift
//  WatchScreenshotGenerator
//
//  Created by Nora Trapp on 4/10/15.
//  Copyright (c) 2015 Trapp Design. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var saveButton: NSButton!
    @IBOutlet weak var radioButtons: NSMatrix!
    @IBOutlet weak var imageView: DropImageView!
    @IBOutlet weak var messageLabel: NSTextField!

    private var userScreenshot: NSImage?
    private let dateFormatter = NSDateFormatter()

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        dateFormatter.dateFormat = "yyyy-MM-dd hh.mm.ss a"

        saveButton.target = self
        saveButton.action = Selector("saveImage")
        saveButton.enabled = false

        radioButtons.target = self
        radioButtons.action = Selector("manipulateImage")

        imageView.completion = { [unowned self] image in
            if let image = image {
                self.userScreenshot = image
                self.messageLabel.hidden = true
                self.manipulateImage()
                self.saveButton.enabled = true
            } else {
                self.userScreenshot = nil
                self.imageView.image = nil
                self.messageLabel.hidden = false
                self.saveButton.enabled = false
            }
        }
    }

    func manipulateImage() {
        let type = ScreenshotType(rawValue: radioButtons.selectedRow)
        if let userScreenshot = userScreenshot, type = type {
            switch type {
            case .App:
                imageView.image = ImageManipulator.appScreenshot(userScreenshot)
            case .Glance:
                imageView.image = ImageManipulator.glanceScreenshot(userScreenshot)
            case .Notification:
                imageView.image = ImageManipulator.notificationScreenshot(userScreenshot)
            }
        }
    }

    func saveImage() {
        let savePanel = NSSavePanel()

        let type = ScreenshotType(rawValue: radioButtons.selectedRow)!
        savePanel.nameFieldStringValue = "Apple Watch " + type.description + " Screenshot " + dateFormatter.stringFromDate(NSDate())
        savePanel.allowedFileTypes = ["jpg"]
        savePanel.beginSheetModalForWindow(window) { [unowned self] result in
            if result == NSFileHandlingPanelOKButton {
                self.writeToDisk(self.imageView.image!, url: savePanel.URL!)
            }
        }
    }

    func writeToDisk(image: NSImage, url: NSURL) {
        let tiffData = image.TIFFRepresentation!
        let imageRep = NSBitmapImageRep(data: tiffData)!
        let imageData = imageRep.representationUsingType(NSBitmapImageFileType.NSJPEGFileType, properties: [NSImageCompressionFactor: 1])
        imageData?.writeToFile(url.path!, atomically: true)
    }
}

enum ScreenshotType: Int, Equatable, Printable {
    case App = 0
    case Glance = 1
    case Notification = 2

    var description: String {
        get {
            switch self {
            case .App:
                return "App"
            case .Glance:
                return "Glance"
            case .Notification:
                return "Notification"
            }
        }
    }
}
