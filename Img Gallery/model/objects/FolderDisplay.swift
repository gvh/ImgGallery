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
    var files: [ImageDisplay] = []

    init(folder: ImageFolder) {
        self.currentFolder = folder
        self.name = folder.noPrefixName
        self.parentName = folder.parentFolder?.noPrefixName ?? ""
    }

    static func create(folder: ImageFolder) -> FolderDisplay {
        let folderDisplay = FolderDisplay(folder: folder)
        for file in folder.files {
            let imageDisplay: ImageDisplay = ImageDisplay()
            imageDisplay.setFile(file: file)
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
