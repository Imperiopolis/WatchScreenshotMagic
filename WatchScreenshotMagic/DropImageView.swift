//
//  DropImageView.swift
//  WatchScreenshotGenerator
//
//  Created by Nathan Trapp on 4/10/15.
//  Copyright (c) 2015 Trapp Design. All rights reserved.
//

import Cocoa

class DropImageView: NSImageView {
    var completion: ((image: NSImage?) -> ())?
    private var draggedImage: NSImage?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func draggingEntered(sender: NSDraggingInfo) -> NSDragOperation {
        var operation: NSDragOperation = .None

        let pasteboard = sender.draggingPasteboard()
        if let filePaths = pasteboard.propertyListForType(NSFilenamesPboardType) as? [String] where filePaths.count == 1 {
            if isImage(filePaths.first!) {
                draggedImage = NSImage(contentsOfFile: filePaths.first!)
                operation = .Copy
            }
        }
        if let _ = sender.draggedImage() {
            operation = .Copy
        }

        return operation
    }

    override func performDragOperation(sender: NSDraggingInfo) -> Bool {
        if let completion = completion, draggedImage = draggedImage {
            completion(image: draggedImage)
        }

        return true
    }

    override func concludeDragOperation(sender: NSDraggingInfo?) {
        draggedImage = nil
    }

    func isImage(path: String) -> Bool {
        var isImage = false

        let fileUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (path as NSString).pathExtension, nil)

        if UTTypeConformsTo(fileUTI!.takeRetainedValue(), kUTTypeImage) {
            isImage = true;
        }

        return isImage
    }
}
