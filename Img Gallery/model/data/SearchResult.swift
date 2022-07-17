//
//  SearchResult.swift
//  MediaBrowser
//
//  Created by Gardner von Holt on 9/15/20.
//

import Foundation

class SearchResult : ObservableObject {
    var hitCount: Int
    var imageFolder: ImageFolder

    init(folder: ImageFolder, hitCount: Int) {
        self.hitCount = hitCount
        self.imageFolder = folder
    }
}

extension SearchResult: Equatable {
    static func == (lhs: SearchResult, rhs: SearchResult) -> Bool {
        let result: Bool =
            lhs.imageFolder.name == rhs.imageFoler.name &&
        return result
    }
}

extension SearchResult: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(folderDisplay.name)
    }

}
