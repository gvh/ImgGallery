//
//  SearchResult.swift
//  MediaBrowser
//
//  Created by Gardner von Holt on 9/15/20.
//

import Foundation

class SearchResult : ObservableObject {
    static var nextId: Int = 1
    var id: Int

    var hitCount: Int
    var imageFolder: ImageFolder

    init(folder: ImageFolder, hitCount: Int) {
        self.id = SearchResult.nextId
        SearchResult.nextId += 1

        self.hitCount = hitCount
        self.imageFolder = folder
    }
}

extension SearchResult: Equatable {
    static func == (lhs: SearchResult, rhs: SearchResult) -> Bool {
        let result: Bool = lhs.imageFolder.name == rhs.imageFolder.name
        return result
    }
}

extension SearchResult: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(imageFolder.name)
    }

}
