//
//  SearchResult.swift
//  MediaBrowser
//
//  Created by Gardner von Holt on 9/15/20.
//

import Foundation

class SearchResult : ObservableObject {
    var hitCount: Int
    var folderDisplay: FolderDisplay

    init(folder: ImageFolder, hitCount: Int) {
        self.hitCount = hitCount
        self.folderDisplay = FolderDisplay(folder: folder)
    }
}

extension SearchResult: Equatable {
    static func == (lhs: SearchResult, rhs: SearchResult) -> Bool {
        let result: Bool =
            lhs.folderDisplay.name == rhs.folderDisplay.name &&
            lhs.folderDisplay.parentName == rhs.folderDisplay.parentName
        return result
    }
}

extension SearchResult: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(folderDisplay.parentName)
        hasher.combine(folderDisplay.name)
    }

}
