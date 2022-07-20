//
//  FolderDisplay.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 7/15/22.
//  Copyright © 2022 Wvh. All rights reserved.
//

import Foundation
import SwiftUI

class FolderDisplay : ObservableObject {
    static var nextId: Int = 1
    var id: Int
    
    var currentFolder: ImageFolder?
    var name: String = ""
    var parentName: String = ""
    var files: [ImageDisplay] = []

    init() {
        self.id = FolderDisplay.nextId
        FolderDisplay.nextId += 1
    }

    func configure(folder: ImageFolder) {
        self.currentFolder = folder
        self.name = folder.noPrefixName
        self.parentName = folder.parentFolder?.noPrefixName ?? ""
        var fileSequence = 0
        for file in folder.files {
            let imageDisplay: ImageDisplay = ImageDisplay()
            imageDisplay.configure(file: file, fileSequence: fileSequence, fileCount: folder.files.count)
            fileSequence += 1
        }
    }

}

extension FolderDisplay : Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(parentName)
    }
}

extension FolderDisplay : Equatable {
    static func == (lhs: FolderDisplay, rhs: FolderDisplay) -> Bool {
        return lhs.name == rhs.name &&
        lhs.parentName == rhs.parentName
    }
}

extension FolderDisplay : Identifiable {
}
