//
//  SearchResult.swift
//  MediaBrowser
//
//  Created by Gardner von Holt on 9/15/20.
//

import Foundation

class SearchResult {
    var hitCount: Int
    var folder: ImageFolder

    init(folder: ImageFolder, hitCount: Int) {
        self.hitCount = hitCount
        self.folder = folder
    }
}

extension SearchResult: Equatable {
    static func == (lhs: SearchResult, rhs: SearchResult) -> Bool {
        return
            lhs.folder.getFullPath() == rhs.folder.getFullPath()
    }
}

extension SearchResult: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(folder.getFullPath())
    }

}
