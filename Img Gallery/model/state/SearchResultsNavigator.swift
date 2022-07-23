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

class SearchResultsNavigator: ObservableObject {
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
        self.configureDisplay()
        self.readImageIfNeeded()
    }

    private func configureDisplay() {
        let file = getCurrentFile()
        guard file != nil else { return }
        AppData.sharedInstance.imageDisplay.configure(file: file!,
                                                      fileSequence: currentPosition,
                                                      fileCount: currentSearchResult!.imageFolder.files.count)
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

    func doSave() {
        let file = getCurrentFile()
        if file != nil {
            DispatchQueue.main.async {
                CustomPhotoAlbum.sharedInstance.saveImage(file: file!) { _ in
                }
            }
        }
    }

    func togglePlayPause() {
        let appData = AppData.sharedInstance
        if Heartbeat.sharedInstance.isTimerActive {
            Heartbeat.sharedInstance.stopTimer()
            appData.isTimerDesired = false
        } else {
            Heartbeat.sharedInstance.startTimer(delegate: self)
            appData.isTimerDesired = true
        }
    }

    func onImageChangeTimer() {
        currentPosition = getRandomPosition()
        self.configureDisplay()
        readImageIfNeeded()
    }

    func setResults(results: [SearchResult]) {
        self.searchResults.removeAll()
        self.searchResults.append(contentsOf: results)
    }


    func setFolderDisplay(folderDisplay: FolderDisplay) {
        for i in 0..<searchResults.count {
            let searchResult = searchResults[i].imageFolder
            if folderDisplay.currentFolder == searchResult {
                currentPosition = i
                break
            }
        }
        return
    }

    private func setPosition() {
        self.readImageIfNeeded()
        self.configureDisplay()
    }

}
extension SearchResultsNavigator : FileNavigator {
    func doGoTo(file: ImageFile) {
    }

    func getCurrentFile() -> ImageFile? {
        guard currentSearchResult != nil else { return nil }
        guard currentSearchResult!.imageFolder.files.count > 0 else { return nil }
        guard currentPosition >= 0 && currentPosition < currentSearchResult!.imageFolder.files.count else { return nil }
        return AppData.sharedInstance.favorites.items[currentPosition].file
    }

    func setCurrentFile(file: ImageFile) {
        if currentSearchResult != nil {
            currentPosition = currentSearchResult!.imageFolder.files.firstIndex (where: { $0 == file } )!
            readImageIfNeeded()
        }
    }

    func getCurrentFilePosition() -> Int {
        return currentPosition
    }

    func setCurrentFilePosition(position: Int) {
        guard position >= 0 && position < currentSearchResult!.imageFolder.files.count else { return }
        currentPosition = position
    }

    func getTotalFiles() -> Int {
        return AppData.sharedInstance.favorites.items.count
    }
    
    func doPrev() {
        self.currentPosition = currentPosition <= 0 ? currentSearchResult!.imageFolder.files.count - 1 : currentPosition - 1
        self.setPosition()
    }

    func doNext() {
        self.currentPosition = currentPosition >= currentSearchResult!.imageFolder.files.count - 1 ? 0 : currentPosition + 1
        self.setPosition()
    }

    func getRandomFile() -> ImageFile? {
        let position = self.getRandomPosition()
        let file = currentSearchResult!.imageFolder.files[position]
        setCurrentFile(file: file)
        return file
    }


    func getRandomPosition() -> Int {
        let totalItems: Int = currentSearchResult!.imageFolder.files.count
        guard totalItems > 0 else { return -1 }
        return Int.random(in: 0..<totalItems)
    }

}

extension SearchResultsNavigator : FolderNavigator {
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

    private func setNewResult() {
        self.currentSearchResult = searchResults[currentSearchResultPosition]
        self.currentPosition = 0
        self.setPosition()
        print("new search result: \(currentSearchResult?.imageFolder.noPrefixName ?? "none")")
    }


}

extension SearchResultsNavigator : HeartbeatDelegate {

    func onBeat() {
        let position = self.getRandomPosition()
        let file = currentSearchResult!.imageFolder.files[position]
        setCurrentFile(file: file)
    }

}
