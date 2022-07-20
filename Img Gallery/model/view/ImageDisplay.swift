//
//  ImageDisplay.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 6/28/22.
//  Copyright © 2022 Wvh. All rights reserved.
//

import Foundation
import SwiftUI

class ImageDisplay : ObservableObject {
    static var nextId: Int = 1
    var id: Int

    var currentFile: ImageFile!

    var name: String = ""
    var image: UIImage = UIImage(systemName: "film")!

    var parentDirectoryName: String = ""
    var directoryName: String = ""
    var fileSequence: Int = -1
    var fileCount: Int = -2

    var isTimerActive: Bool = false
    var countDownSeconds: Int = 0

    init() {
        id = ImageDisplay.nextId
        ImageDisplay.nextId += 1
    }

    func configure(file: ImageFile, fileSequence: Int, fileCount: Int)  {
        DispatchQueue.main.async {
            self.objectWillChange.send()
            self.currentFile = file
            self.directoryName = file.textDirectoryName
            self.parentDirectoryName = file.parentFolder.noPrefixName
            self.fileSequence = fileSequence
            self.fileCount = fileCount
            self.countDownSeconds = 0
        }
    }

    func updateImage(file: ImageFile) {
        DispatchQueue.main.async {
            self.objectWillChange.send()
            self.image = file.image
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
