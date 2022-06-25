//
//  KeywordElement.swift
//  mediatransport
//
//  Created by Gardner von Holt on 8/9/19.
//  Copyright © 2019 Gardner von Holt. All rights reserved.
//

import Foundation

class SearchUsage {
    var name: String
    var filesInTree: Int = 0
    var folders: [ImageFolder] = []

    static func create(searchName: String) -> SearchUsage {
        let searchUsage = SearchUsage(name: searchName)
        return searchUsage
    }

    private init(name: String) {
        self.name = name.lowercased()
        let appData = AppData.sharedInstance
        let allFolders = appData.downloadAllFolders
        self.folders.append(contentsOf: allFolders.filter { $0.name.lowercased().contains(name) })
    }

    func add(folder: ImageFolder) {
        folders.append(folder)
        filesInTree += folder.filesInTree
    }

    func getFolders() -> [ImageFolder] {
        return folders
    }

    func getFolderCount() -> Int {
        return folders.count
    }

    func getFileCount() -> Int {
        return filesInTree
    }

    func getFile(position: Int) -> ImageFile {
        var positionIndex = position
        for folder in folders.makeIterator() {
            if positionIndex < folder.filesInTree {
                return folder.files[positionIndex]
            } else {
                positionIndex -= folder.filesInTree
            }
        }
        return folders[0].files[0]
    }

    func sortUsage() {
        folders.sort(by: { getSortString(folder: $0)  < getSortString(folder: $1) })
    }

    func getSortString(folder: ImageFolder) -> String {
        let parentFolderName: String = folder.parentFolder?.name ?? ""
        let folderName: String = folder.noPrefixName
        let sortString = parentFolderName + " " + folderName
        return sortString
    }
}

extension SearchUsage: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

extension SearchUsage: Equatable {
    static func == (lhs: SearchUsage, rhs: SearchUsage) -> Bool {
        return
            lhs.name == rhs.name
    }

}
