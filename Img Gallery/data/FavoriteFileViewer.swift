//
//  FavoriteFileViewer.swift
//  MediaBrowser
//
//  Created by Gardner von Holt on 9/13/20.
//

import Foundation

class FavoriteFileViewer {
    var currentPosition: Int = 0
    let imageLoader = ImageLoader()
    static var formatter = DateFormatter()
    var lastRandomNumber: Int = -1

    init() {
        FavoriteFileViewer.formatter.dateFormat = "yyyy-MMM-dd"
    }
}

extension FavoriteFileViewer: FileDataSource {

    func getSequentialFile() -> ImageFile {
        return goForwards()
    }

    func getAllFiles() -> [ImageFile] {
        return AppData.sharedInstance.favorites.items.map { $0.file }
    }

    func getDisplayPositionDetails() -> (Int, Int) {
        let lastRandomNumberDisplay = lastRandomNumber + 1
        return (lastRandomNumberDisplay, AppData.sharedInstance.favorites.items.count)
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
        let formattedDate: String = FavoriteFileViewer.formatter.string(from: AppData.sharedInstance.favorites.items[row].dateAdded)
        return formattedDate
    }

    func setFolder(folder: ImageFolder) {
    }

    func getFile(position: Int) -> ImageFile {
        return AppData.sharedInstance.favorites.items[position].file
    }

    func goBackwards() -> ImageFile {
        if currentPosition > 0 {
            currentPosition -= 1
        } else {
            currentPosition = AppData.sharedInstance.favorites.items.count - 1
        }
        let file = AppData.sharedInstance.favorites.items[currentPosition].file
        ImageLoader.readImage(file: file) { _ in }
        return file
    }

    func goForwards() -> ImageFile {
        if (currentPosition + 1) < AppData.sharedInstance.favorites.items.count {
            currentPosition += 1
        } else {
            currentPosition = 0
        }
        let file = AppData.sharedInstance.favorites.items[currentPosition].file
            ImageLoader.readImage(file: file) { _ in }
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
        let favorites = AppData.sharedInstance.favorites
        return favorites.items[currentPosition].file
    }

    func getRowCount() -> Int {
        return AppData.sharedInstance.favorites.items.count
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
        return "favorite".localizedWithComment(comment: "label in favorite file viewer")
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

    func getRandomFile() -> ImageFile {
        let totalItems: Int = AppData.sharedInstance.favorites.items.count

        guard totalItems > 0 else {
            let defaultFile = ImageFile(name: "default")
            lastRandomNumber = totalItems
            return defaultFile
        }
        let maxItems = totalItems - 1
        lastRandomNumber = Int.random(in: 0...maxItems)
        let randomFile = AppData.sharedInstance.favorites.items[lastRandomNumber].file
        return randomFile
    }

    func getCurrentLocation() -> (Int, Int) {
        let totalItems: Int = AppData.sharedInstance.favorites.items.count
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
        return "favorite".localizedWithComment(comment: "label in favorite file viewer")
    }

    func getDisplaySequenceLabel() -> String {
        return ""
    }
}
