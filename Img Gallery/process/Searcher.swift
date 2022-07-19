//
//  SearchProcess.swift
//  mediatransport
//
//  Created by Gardner von Holt on 11/4/19.
//  Copyright © 2019 Gardner von Holt. All rights reserved.
//

import Foundation

class Searcher: NSObject {

    var appData = AppData.sharedInstance

    var searchFolders: [SearchResult] = []

    var matchedFoldersDictionary: [String: SearchResult] = [:]

    var useAnd = false

    func search(searchText: String) -> [SearchResult] {

        let searchTextLower = searchText.lowercased()

        // Clear counts and prepare for search
        ImageFolder.clearSearchCounts()

        // parse the input into an array of search terms
        var searchWords = getSearchWords(search: searchTextLower)
        if searchWords.contains("and") {
            useAnd = true
            searchWords.removeAll { $0 == "and" }
        }

        matchedFoldersDictionary.removeAll()
        for searchWord in searchWords {
            let searchWordString = String(searchWord)
            let matchingFolders = getMatchingFolders(searchWord: searchWordString)
            mergeFoldersIntoDictionary(folders: matchingFolders)
        }

        // From the dictionary, take just the folders and make an array of them
        let mergedFoldersArray = Array(matchedFoldersDictionary.values)

        // Sort the folders on the search Raking, descending, so the folders with the most matching search terms show first
        searchFolders.removeAll()
        searchFolders.append(contentsOf: mergedFoldersArray.sorted(by: { $0.hitCount > $1.hitCount }) )

        // Remove all folders matching the words on the ignore list
        if !appData.settingsStore.ignoreFoldersContainingSet.isEmpty {
            for ignoreFolder in appData.settingsStore.ignoreFoldersContainingSet {
                searchFolders.removeAll { $0.imageFolder.getTokens().contains(ignoreFolder) }
            }
        }

        // Remove all folders not matching everything if we are in and "and"
        if useAnd {
            let searchWordsCount = searchWords.count
            searchFolders.removeAll { $0.hitCount < searchWordsCount }
        }

        return searchFolders
    }

    func getSearchWords(search: String) -> [String] {
        var searchWords: [String] = []
        let searchText = search.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
        let searchStringWords = searchText.split(separator: " ")
        for searchStringWord in searchStringWords {
            searchWords.append(String(searchStringWord))
        }
        return searchWords
    }

    func getMatchingFolders(searchWord: String) -> [ImageFolder] {
        var searchFolderDictionary: [String: ImageFolder] = [:]

        // searchActualWord is what to search for, and generic is true if we should match any word beginning with the named string
        var searchActualWord: String = ""
        var generic = false
        if searchWord.endsWith("*") || searchWord.endsWith("%") {
            searchActualWord = String(searchWord.dropLast())
            generic = true
            print("generic searchword shortened to \(searchActualWord)")
        } else {
            searchActualWord = searchWord
        }

        // reduce the keyword array to just the keywords matching the beginning of the name entered
        let keywords: [KeywordUsage] = generic == true ?
            appData.keywordIndex.keywords.values.filter { $0.name.beginsWith(searchActualWord) } :
                appData.keywordIndex.keywords[searchActualWord] == nil ?
                    [] :
                    [appData.keywordIndex.keywords[searchActualWord]!]

        // debugging section
//        var keywordNames:[String] = []
//        for keyword in keywords {
//            keywordNames.append(keyword.name)
//        }

        // the keywords array can contain one or many words, representing either a specific search or a search for any of a number of words
        // for each matching keyword, find all the matching folders and add them to the searchFolderDictionary
        // searchFolderDictionary will contain the foldernames and folders for each folder matching any variation of the keyword
        searchFolderDictionary.removeAll()
        for keyword in keywords {
            let folders = keyword.getFolders()
            for folder in folders {
                let folderName = folder.getFullPath()
                searchFolderDictionary[folderName] = folder
            }
        }

        // build up the final list of matching folders and return to caller
        var matchingFolders: [ImageFolder] = []
        let sortedFolderDictionary = searchFolderDictionary.sortedByKey
        for element in sortedFolderDictionary {
            matchingFolders.append(element.1)
        }
        return matchingFolders
    }

    func mergeFoldersIntoDictionary(folders: [ImageFolder]) {
        for folder in folders {
            let folderName = folder.getFullPath()
            let searchIndex = matchedFoldersDictionary.index(forKey: folderName)
            if searchIndex == nil {
                // if the folder was not found, add it with a "1" counter
                let searchResult = SearchResult(folder: folder, hitCount: 1)
                matchedFoldersDictionary[folderName] = searchResult
            } else {
                // if already in the dictionary, just add 1 to the search counter
                let searchResult = matchedFoldersDictionary[searchIndex!]
                searchResult.value.hitCount += 1
            }
        }
    }
}
