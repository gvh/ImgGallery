//
//  TableOfContents.swift
//  mediatransport
//
//  Created by Gardner von Holt on 8/10/19.
//  Copyright © 2019 Gardner von Holt. All rights reserved.
//

import Foundation

class TableOfContents: ObservableObject {
    @Published private(set) var rootFolder: ImageFolder!
    var allFiles: [String: ImageFile] = [:]

    private init() {
    }

    init(rootFolder: ImageFolder) {
        self.rootFolder = rootFolder
    }

    func find(name: String) -> ImageFile? {
        var tokens: [String] = name.components(separatedBy: "/")
        var folder = rootFolder
        while tokens.count > 1 {
            let token = tokens[0]
            tokens.remove(at: 0)
            let subFolder = folder?.subFolder(token)
            if subFolder == nil {
                let notFoundInFolder = "notfound.infolder".localizedWithComment(comment: "message in table of contents")
                print("\(token) \(notFoundInFolder) \(folder?.getFullPath() ?? "")")
            } else {
                folder = subFolder
            }
        }
        let token = tokens[0]
        let file = folder?.getFile(name: token)
        return file
    }

    func populateIndex() {
        self.allFiles.removeAll()
        scanFolder(folder: rootFolder)
    }

    func scanFolder(folder: ImageFolder) {
        for subFolder in folder.subFolders.values {
            scanFolder(folder: subFolder)
        }

        for file in folder.files {
            let key = file.parentFolder.name + "/" + file.name
            let testItem = allFiles[key]
            if testItem != nil {
                let duplicateNames = "duplicate.names".localizedWithComment(comment: "message in table of contents")
                let andWord = "and".localizedWithComment(comment: "message in table of contents")
                let fullPath = String(describing: testItem?.getFullPath())
                print("\(duplicateNames) : \(file.getFullPath()) \(andWord) \(fullPath)")
            }
            allFiles[key] = file
        }

    }

    func getFileByKey(folderName: String, fileName: String) -> ImageFile? {
        let key = folderName + "/" + fileName
        let file = allFiles[key]
        return file
    }
}
