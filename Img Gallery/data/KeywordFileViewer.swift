//
//  FolderFileViewer.swift
//  MediaBrowser
//
//  Created by Gardner von Holt on 9/13/20.
//

import Foundation
import SwiftUI
import Combine

class KeywordFileViewer {
    var keywordUsage: KeywordUsage?
    var currentPosition = 0
    let imageLoader = ImageLoader()
    var lastRandomNumber: Int = -1

    init(keywordUsage: KeywordUsage?) {
        self.keywordUsage = keywordUsage
    }
}

extension KeywordFileViewer: FileDataSource {

    func getSequentialFile() -> ImageFile {
        return goForwards()
    }

    func getAllFiles() -> [ImageFile] {
        return []
    }

    func getDisplayPositionDetails() -> (Int, Int) {
        let lastRandomNumberDisplay = lastRandomNumber + 1
        return (lastRandomNumberDisplay, keywordUsage!.filesInTree)
    }

    func isRandom() -> Bool {
        return false
    }

    func onAppear() {
    }

    func onDisappear() {
    }

    func onSubscriptionTimer() {
    }

    func onProgress(timer: RefreshTimer) {
    }

    func setImageSelectionDelegate(delegate: ImageSelectionDelegate?) {
    }

    func hasFullScreenButton() -> Bool {
        return true
    }

    func getScreenLabel(row: Int) -> String {
        let rowDisplay = row + 1
        let returnLabel = "\(rowDisplay)"
        return returnLabel
    }

    func getFile(position: Int) -> ImageFile {
        return keywordUsage!.getFile(position: position)
    }

    func goBackwards() -> ImageFile {
        if currentPosition > 0 {
            currentPosition -= 1
        } else {
            currentPosition = keywordUsage!.filesInTree - 1
        }
        let file = keywordUsage!.getFile(position: currentPosition)
        withAnimation(.default) {
            ImageLoader.readImage(file: file) { _ in }
        }
        return file
    }

    func goForwards() -> ImageFile {
        if (currentPosition + 1) < keywordUsage!.filesInTree {
            currentPosition += 1
        } else {
            currentPosition = 0
        }
        let file = keywordUsage!.getFile(position: currentPosition)
        withAnimation(.default) {
            ImageLoader.readImage(file: file) { _ in }
        }
        return file
    }

    func hasBackButton() -> Bool {
        return true
    }

    func hasNextButton() -> Bool {
        return true
    }

    func hasGoToButton() -> Bool {
        return true
    }

    func hasPlayPauseButton() -> Bool {
        return false
    }

    func getCurrentFile() -> ImageFile {
        return keywordUsage!.getFile(position: currentPosition)
    }

    func getCurrentFolder() -> ImageFolder {
        return getCurrentFile().parentFolder
    }

    func setCurrentPosition(_ position: Int) {
        currentPosition = position
    }

    func getCurrentPosition() -> Int {
        return currentPosition
    }

    func getName() -> String {
        let file = keywordUsage!.getFile(position: currentPosition)
        let folderLabel = "folder.label".localizedWithComment(comment: "label in keyword file viewer")
        return "\(folderLabel) \(file.parentFolder.getName())"
    }

    func doSave(file: ImageFile) {
        CustomPhotoAlbum.sharedInstance.saveImage(file: file) { _ in
        }
    }

    func togglePlayPause() {
    }

    func doNext() {
        _ = goForwards()
    }

    func doPrev() {
        _ = goBackwards()
    }

    func getRowCount() -> Int {
        return keywordUsage!.filesInTree
    }

    func getRandomFile() -> ImageFile {
        let totalItems: Int = keywordUsage!.filesInTree
        guard totalItems > 0 else {
            let defaultFile = ImageFile(name: "default")
            lastRandomNumber = totalItems
            return defaultFile
        }

        let maxItems = totalItems - 1
        lastRandomNumber = Int.random(in: 0...maxItems)
        let randomFile = keywordUsage!.getFile(position: lastRandomNumber)
        return randomFile
    }

    func getCurrentLocation() -> (Int, Int) {
        let totalItems: Int = keywordUsage!.filesInTree
        guard totalItems > 0 else {
            return (1, 1)
        }

        let lastDisplayRandomNumber = lastRandomNumber + 1
        return (lastDisplayRandomNumber, totalItems)
    }

    func getBasePath() -> String? {
        let file = keywordUsage!.getFile(position: currentPosition)
        let folder = file.parentFolder
        return folder.getFullPath()
    }

    func getTitle() -> String {
        return "keyword".localizedWithComment(comment: "label in keyword file viewer")
    }

    func getDisplaySequenceLabel() -> String {
        return ""
    }
}