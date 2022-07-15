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
    var currentFolder: ImageFolder!
    var navigator: Navigator?

    var name: String = ""
    var parentName: String = ""
    var subFolders: [FolderDisplay] = []
    var folder: ImageFolder;

    private init(folder: ImageFolder) {
        self.folder = folder
        self.name = folder.noPrefixName
        self.parentName = folder.parentFolder?.noPrefixName ?? ""
    }

    static func create(folder: ImageFolder) -> FolderDisplay {
        let folderDisplay = FolderDisplay(folder: folder)
        for folder in folder.subFolderValues {
            let subFolderDisplay = FolderDisplay.create(folder: folder)
            folderDisplay.subFolders.append(subFolderDisplay)
        }
        return folderDisplay
    }

    func setDirectory(folder: ImageFolder) {
    }
}
