//
//  ImageDisplay.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 6/28/22.
//  Copyright © 2022 Wvh. All rights reserved.
//

import Foundation
import SwiftUI

enum DisplayStatus: Int {
    case Placeholder = 1
    case Image = 2
    case Broken = 3
}

class ImageDisplay : ObservableObject {
    static var nextId: Int = 1
    var id: Int

    var currentFile: ImageFile!

    var name: String = ""
    var image: UIImage = UIImage(systemName: "film")!

    var imageStatus: DisplayStatus = .Placeholder

    var parentDirectoryName: String = ""
    var directoryName: String = ""
    var fileSequence: Int = -1
    var fileCount: Int = -2

    var isTimerActive: Bool = false
    var countDownSeconds: Double = 0

    init() {
        id = ImageDisplay.nextId
        ImageDisplay.nextId += 1
    }

    func configure(fileNavigator: FileNavigator) {
        if let file = fileNavigator.getCurrentFile() {
            let fileSequence = fileNavigator.getCurrentFilePosition()
            let fileCount = fileNavigator.getTotalFiles()
            self.configure(file: file, fileSequence: fileSequence, fileCount: fileCount)
        }
    }

    func configure(file: ImageFile, fileSequence: Int, fileCount: Int)  {
        DispatchQueue.main.async {
            if self.currentFile != file {
                print("new configured for \(file.name)")
                self.objectWillChange.send()
                self.currentFile = file
                self.directoryName = file.textDirectoryName
                self.parentDirectoryName = file.parentFolder.noPrefixName
                self.fileSequence = fileSequence
                self.fileCount = fileCount
                self.countDownSeconds = 0
            } else {
                print("reconfigured for \(self.currentFile.name)")
            }
        }
    }

    func setTimerActive(value: Bool) {
        DispatchQueue.main.async {
            self.objectWillChange.send()
            self.isTimerActive = value
        }
    }

    func updateImage() {
        DispatchQueue.main.async {
            guard self.imageStatus != .Image else { return }

            if self.imageStatus == .Placeholder && self.currentFile.imageStatus == .DownloadComplete {
                self.objectWillChange.send()
                self.image = self.currentFile.image
                self.imageStatus = .Image
            }
        }
    }
}

extension ImageDisplay : Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension ImageDisplay : Equatable {
    static func == (lhs: ImageDisplay, rhs: ImageDisplay) -> Bool {
        return lhs.id == rhs.id
    }
}

extension ImageDisplay : Identifiable {
}
