//
//  KeywordIndex.swift
//  MediaBrowser
//
//  Created by Gardner von Holt on 7/30/19.
//  Copyright © 2019 Gardner von Holt. All rights reserved.
//

import Foundation

class KeywordIndex {

    var keywords: [String: KeywordUsage] = [:]
    var firstLetters: [String] = []
    var firstLettersUnique: [String] = []

    static func load(folder: ImageFolder) -> KeywordIndex {
        let keywordIndex = KeywordIndex()
        keywordIndex.add(folder: folder)
        keywordIndex.firstLetters = keywordIndex.keywords.keys.map { String($0.prefix(1).uppercased()) }.sorted(by: { $0 < $1 })
        keywordIndex.firstLettersUnique = keywordIndex.firstLetters.unique()
        return keywordIndex
    }

    private func add(folder: ImageFolder) {
        if folder.subFolderValues.isEmpty {
            let tokenStrings = getTokens(folder: folder).sorted()
            for tokenString in tokenStrings where tokenString.count > 2 {
                var keywordElement = keywords[tokenString]
                if keywordElement == nil {
                    keywordElement = KeywordUsage(name: tokenString)
                    keywords[tokenString] = keywordElement
                }
                keywordElement!.add(folder: folder)
            }
        } else {
            for folder in folder.subFolderValues {
                add(folder: folder)
            }
        }
    }

    private func getTokens(folder: ImageFolder) -> [String] {
        var tokenStrings: [String] = []
        var finalTokenStrings: [String] = []

        let folderName: String = folder.name
        let tokens: [String.SubSequence] = folderName.split(separator: " ")
        for token in tokens where token.count >= 3 {
            let tokenString = String(token).lowercased()
            if !StopWords.isStopWord(word: tokenString) {
                tokenStrings.append(tokenString)
            }
        }
        let uniqueTokenStrings = Array(Set(tokenStrings)).sorted()
        for uniqueTokenString in uniqueTokenStrings {
            finalTokenStrings.append(uniqueTokenString)
        }
        return finalTokenStrings
    }

    func getKeywordFolders(keyword: String) -> KeywordUsage {
        var keywordElement = keywords[keyword]
        if keywordElement == nil {
            keywordElement = KeywordUsage(name: keyword)
        }
        return keywordElement!
    }

    func getKeywordCount() -> Int {
        return keywords.count
    }

    func indexPathFor(_ title: String) -> IndexPath {
        let index = firstLetters.firstIndex(where: { $0.hasPrefix(title) })
        let indexPath = IndexPath(row: index!, section: 0)
        return indexPath
    }
}
