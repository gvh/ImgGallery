//
//  SearchResultsNavigator.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 7/16/22.
//  Copyright © 2022 Wvh. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class SearchResultsNavigator: Navigator, ObservableObject {
    var searchResults: [SearchResult] = []

    var currentSearchResult: SearchResult?
    var currentSearchResultPosition: Int

    var currentPosition: Int
    var lastRandomNumber: Int = -1

    init(searchResults: [SearchResult]) {
        self.searchResults.append(contentsOf: searchResults)
        self.currentPosition = 0
        self.currentSearchResultPosition = 0

        print("new search results navigator: \(currentPosition)")
        readImageIfNeeded()
        self.configureImageDisplay()
        self.readImageIfNeeded()
    }

    private func configureDisplay() {
        let file = getCurrentFile()
        guard file != nil else { return }
        AppData.sharedInstance.imageDisplay.configure(file: file,
                                                      directoyName: currentSearchResult!.imageFolder.noPrefixName,
                                                      parentDirectoryName: currentSearchResult!.imageFolder.parentName,
                                                      fileSequence: currentPosition,
                                                      fileCount: currentSearchResult!.folderDisplay.files.count)
    }

    private func setNewResult() {
        self.currentSearchResult = searchResults[currentSearchResultPosition]
        self.currentPosition = 0
        self.setNames()
        self.setPosition()
        print("new search result: \(currentSearchResult?.folderDisplay.name ?? "none")")
    }

    private func setPosition() {
        self.configureImageDisplay()
        self.readImageIfNeeded()
        self.configureDisplay()
    }

    func doPrevResult() {
        print("search do next result")
        if searchResults.count > 0 {
            self.currentSearchResultPosition = currentSearchResultPosition <= 0 ? searchResults.count - 1 : currentSearchResultPosition - 1
            self.setNewResult()
        }
    }

    func doNextResult() {
        print("search do Next result")
        if searchResults.count > 0 {
            self.currentSearchResultPosition = currentSearchResultPosition >= searchResults.count - 1 ? 0 : currentSearchResultPosition + 1
            self.setNewResult()
        }
    }

    func doPrev() {
        self.currentPosition = currentPosition <= 0 ? currentSearchResult!.folderDisplay.files.count - 1 : currentPosition - 1
        self.setPosition()
    }

    func doNext() {
        self.currentPosition = currentPosition >= currentSearchResult!.folderDisplay.files.count - 1 ? 0 : currentPosition + 1
        self.setPosition()
    }

    func doGoTo() {
        print("do go to")
    }

    private func readImageIfNeeded() {
        let currentFile = getCurrentFile()

        guard currentFile != nil else { return }
        guard currentFile?.image == nil else { return }

        withAnimation(.default) {
            ImageLoader.readImage(file: currentFile!) { file in
                AppData.sharedInstance.imageDisplay.updateImage(file: file)
            }
        }
    }

    func getTotalFiles() -> Int {
        return AppData.sharedInstance.favorites.items.count
    }

    func doSave() {
       let file = getCurrentFile()
       if file != nil {
                CustomPhotoAlbum.sharedInstance.saveImage(file: file!) { _ in
            }
        }
    }

    func togglePlayPause() {
        let appData = AppData.sharedInstance
        if appData.imageDisplay.isTimerActive {
            appData.stopTimer()
            appData.isTimerDesired = false
        } else {
            appData.startTimer(navigator: self)
            appData.isTimerDesired = true
        }
    }

    func setButtons() {
        AppData.sharedInstance.imageDisplay.setButtons(hasResultButtons: true, hasBackButton: true, hasNextButton: true, hasSaveButton: true, hasGoToButton: false, hasPlayPauseButton: false)
    }

    func onSubscriptionTimer() {
        currentPosition = getRandomPosition()
        self.configureImageDisplay()
        readImageIfNeeded()
    }

    func getRandomFile() -> ImageDisplay? {
        let position = self.getRandomPosition()
        let file = currentSearchResult!.folderDisplay.files[position]
        return file
    }

    func getRandomPosition() -> Int {
        let totalItems: Int = currentSearchResult!.folderDisplay.files.count
        guard totalItems > 0 else { return -1 }
        return Int.random(in: 0..<totalItems)
    }

    func setResults(results: [SearchResult]) {
        self.searchResults.removeAll()
        self.searchResults.append(contentsOf: results)
    }

    func setFolderDisplay(folderDisplay: FolderDisplay) {
        for i in 0..<searchResults.count {
            let searchResult = searchResults[i].folderDisplay
            if folderDisplay.currentFolder == searchResult.currentFolder {
                currentPosition = i
                break
            }
        }
        return
    }

    func getCurrentFile() -> ImageDisplay? {
        guard AppData.sharedInstance.favorites.items.count > 0 else { return nil }
        guard currentPosition >= 0 && currentPosition < AppData.sharedInstance.favorites.items.count else { return nil }

        return AppData.sharedInstance.favorites.items[currentPosition].file.imageDisplay
    }

    func setCurrentFile(file: ImageDisplay) {
        if currentSearchResult != nil {
            currentPosition = currentSearchResult!.folderDisplay.files.firstIndex (where: { $0 == file } )!
            readImageIfNeeded()
        }
    }


}
