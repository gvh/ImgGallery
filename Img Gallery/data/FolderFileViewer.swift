//
//  FolderFileViewer.swift
//  MediaBrowser
//
//  Created by Gardner von Holt on 9/13/20.
//

import Foundation
import SwiftUI
import Combine

class FolderFileViewer {
    var folder: ImageFolder
    var currentPosition = 0
    let imageLoader = ImageLoader()
    var lastRandomNumber: Int = -1

    var rootSource: FileSubViewerType!
    var rootParameter: String!
    var rootName: String!
    var rootCurrentPosition: Int!

    init(folder: ImageFolder) {
        self.folder = folder
    }

}

extension FolderFileViewer: FileDataSource {

    func getSequentialFile() -> ImageFile {
        return goForwards()
    }

    func getAllFiles() -> [ImageFile] {
        return folder.files
    }

    func isRandom() -> Bool {
        return false
    }

    func getDisplayPositionDetails() -> (Int, Int) {
        let lastRandomNumberDisplay = lastRandomNumber + 1
        return (lastRandomNumberDisplay, folder.filesInTree)
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
        return folder.files[position]
    }

    func goBackwards() -> ImageFile {
        if currentPosition > 0 {
            currentPosition -= 1
        } else {
            currentPosition = folder.files.count - 1
        }
        let file = folder.files[currentPosition]
        withAnimation(.default) {
            ImageLoader.readImage(file: file) { _ in }
        }
        return file
    }

    func goForwards() -> ImageFile {
        if (currentPosition + 1) < folder.files.count {
            currentPosition += 1
        } else {
            currentPosition = 0
        }
        let file = folder.files[currentPosition]
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
        return false
    }

    func hasPlayPauseButton() -> Bool {
        return false
    }

    func getCurrentFile() -> ImageFile {
        return folder.files[currentPosition]
    }

    func getCurrentFolder() -> ImageFolder {
        return folder
    }

    func setCurrentPosition(_ position: Int) {
        currentPosition = position
    }

    func getCurrentPosition() -> Int {
        return currentPosition
    }

    func getName() -> String {
        let folderLabel = "folder.label".localizedWithComment(comment: "label in folder")
        return "\(folderLabel) \(folder.getName())"
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
        return folder.files.count
    }

    func getRandomFile() -> ImageFile {
        let totalItems: Int = folder.filesInTree
        guard totalItems > 0 else {
            let defaultFile = ImageFile(name: "default")
            lastRandomNumber = totalItems
            return defaultFile
        }
        let maxItems = totalItems - 1
        lastRandomNumber = Int.random(in: 0...maxItems)
        let randomFile = folder.getFile(atSequence: lastRandomNumber)
        return randomFile
    }

    func getCurrentLocation() -> (Int, Int) {
        let totalItems: Int = folder.filesInTree
        guard totalItems > 0 else {
            return (1, 1)
        }

        let lastDisplayRandomNumber = lastRandomNumber + 1
        return (lastDisplayRandomNumber, totalItems)
    }

    func getBasePath() -> String? {
        return folder.getFullPath()
    }

    func getTitle() -> String {
        return folder.isRoot ? "All".localizedWithComment(comment: "label in folder file viewer") : folder.noPrefixName
    }

    func getDisplaySequenceLabel() -> String {
        return ""
    }
}
