//
//  HistoryFileViewer.swift
//  MediaBrowser
//
//  Created by Gardner von Holt on 9/19/20.
//

import Foundation
import SwiftUI
import Combine

class HistoryFileViewer {
    var currentPosition = 0
    let imageLoader = ImageLoader()
    static var formatter = DateFormatter()
    var lastRandomNumber: Int = -1

    init() {
        HistoryFileViewer.formatter.dateFormat = "yyyy-MMM-dd"
    }
}

extension HistoryFileViewer: FileDataSource {

    func getSequentialFile() -> ImageFile {
        return goForwards()
    }

    func getAllFiles() -> [ImageFile] {
        return AppData.sharedInstance.histories.items.map { $0.file }
    }

    func isRandom() -> Bool {
        return false
    }

    func getDisplayPositionDetails() -> (Int, Int) {
        let lastRandomNumberDisplay = lastRandomNumber + 1
        return (lastRandomNumberDisplay, AppData.sharedInstance.histories.items.count)
    }

    func onAppear() {
    }

    func onDisappear() {
    }

    func onSubscriptionTimer() {
    }

    func onProgress(timer: RefreshTimer) {
    }

    func hasFullScreenButton() -> Bool {
        return true
    }

    func setImageSelectionDelegate(delegate: ImageSelectionDelegate?) {
    }

    func getScreenLabel(row: Int) -> String {
        let formattedDate: String = HistoryFileViewer.formatter.string(from: AppData.sharedInstance.histories.items[row].dateAdded)
        return formattedDate
    }

    func setFolder(folder: ImageFolder) {
    }

    func getFile(position: Int) -> ImageFile {
        return AppData.sharedInstance.histories.items[position].file
    }

    func goBackwards() -> ImageFile {
        if currentPosition > 0 {
            currentPosition -= 1
        } else {
            currentPosition = AppData.sharedInstance.histories.items.count - 1
        }
        let file = AppData.sharedInstance.histories.items[currentPosition].file
        withAnimation(.default) {
            imageLoader.readImage(file: file) { _ in }
        }
        return file
    }

    func goForwards() -> ImageFile {
        if (currentPosition + 1) < AppData.sharedInstance.histories.items.count {
            currentPosition += 1
        } else {
            currentPosition = 0
        }
        let file = AppData.sharedInstance.histories.items[currentPosition].file
        withAnimation(.default) {
            imageLoader.readImage(file: file) { _ in }
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
        return AppData.sharedInstance.histories.items[currentPosition].file
    }

    func getRowCount() -> Int {
        return AppData.sharedInstance.histories.items.count
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
        return "History".localizedWithComment(comment: "label in history file viewer")
    }

    func doSave(file: ImageFile) {
        CustomPhotoAlbum.sharedInstance.saveImage(file: file) { _ in
        }
    }

    func togglePlayPause() {
    }

    func doPrev() {
        _ = goBackwards()
    }

    func doNext() {
        _ = goForwards()
    }

    func getRandomFile() -> ImageFile {
        let totalItems: Int = AppData.sharedInstance.histories.items.count

        guard totalItems > 0 else {
            let defaultFile = ImageFile(name: "default")
            lastRandomNumber = totalItems
            return defaultFile
        }

        let maxItems = totalItems - 1
        lastRandomNumber = Int.random(in: 0...maxItems)

        let randomFile = AppData.sharedInstance.histories.items[lastRandomNumber].file
        return randomFile
    }

    func getCurrentLocation() -> (Int, Int) {
        let totalItems: Int = AppData.sharedInstance.histories.items.count
        guard totalItems > 0 else {
            return (1, 1)
        }

        let lastDisplayRandomNumber = lastRandomNumber + 1
        return (lastDisplayRandomNumber, totalItems)
    }

    func getBasePath() -> String? {
        return ""
    }

    func getTitle() -> String {
        return "history".localizedWithComment(comment: "label in history file viewer")
    }

    func getDisplaySequenceLabel() -> String {
        return ""
    }
}
