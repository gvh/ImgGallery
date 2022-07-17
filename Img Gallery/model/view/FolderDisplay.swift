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
    
    var currentFolder: ImageFolder
    var name: String = ""
    var parentName: String = ""
    var files: [ImageDisplay] = []

    convenience init() {
        let rootFolder = AppData.sharedInstance.downloadTOC.rootFolder
        if (rootFolder != nil) {
            self.init(folder: rootFolder!)
        }
    }

    init(folder: ImageFolder) {
        self.currentFolder = folder
        self.name = folder.noPrefixName
        self.parentName = folder.parentFolder?.noPrefixName ?? ""
        super.init()
    }

    func configure(folder: ImageFolder) {
        self.currentFolder = folder
        self.name = folder.noPrefixName
        self.parentName = folder.parentFolder?.noPrefixName ?? ""
        for file in folder.files {
            let imageDisplay: ImageDisplay = ImageDisplay()
            imageDisplay.configure(file: <#T##ImageFile#>, hasResultButtons: <#T##Bool#>, hasBackButton: <#T##Bool#>, hasNextButton: <#T##Bool#>, hasSaveButton: <#T##Bool#>, hasGoToButton: <#T##Bool#>, hasPlayPauseButton: <#T##Bool#>, fileSequence: <#T##Int#>, fileCount: <#T##Int#>, isTimerActive: <#T##Bool#>)
        }
        return folderDisplay
    }

    func getTokens() -> [String] {
        var tokenStrings: [String] = []
        var finalTokenStrings: [String] = []
        let tokens: [String.SubSequence] = name.split(separator: " ")
        for token in tokens where token.count > 2 {
            let tokenString = String(token).lowercased()
            tokenStrings.append(tokenString)
        }
        let uniqueTokenStrings = Array(Set(tokenStrings)).sorted()
        for uniqueTokenString in uniqueTokenStrings {
            finalTokenStrings.append(uniqueTokenString)
        }
        return finalTokenStrings
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
