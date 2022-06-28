//
//  FolderFileViewer.swift
//  MediaBrowser
//
//  Created by Gardner von Holt on 9/13/20.
//

import Foundation
import SwiftUI
import Combine

class FolderFileViewer : ObservableObject {
    @Published var hasBackButtonVar: Bool = true
    @Published var hasNextButtonVar: Bool = true
    @Published var hasGoToButtonVar: Bool = false
    @Published var hasSaveButtonVar: Bool = true
    @Published var hasPlayPauseButtonVar: Bool = false

    @Published var currentFile: ImageFile

    @Published var folder: ImageFolder
    @Published var currentPosition = 0
    let imageLoader = ImageLoader()
    var lastRandomNumber: Int = -1

    var rootSource: FileSubViewerType!
    var rootParameter: String!
    var rootName: String!
    var rootCurrentPosition: Int!

    init(folder: ImageFolder) {
        self.folder = folder
        self.currentFile = folder.files[0]
    }

    init(folder: ImageFolder, position: Int) {
        self.folder = folder
        self.currentPosition = position
        self.currentFile = folder.files[position]
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
        self.currentFile = folder.files[currentPosition]
        withAnimation(.default) {
            ImageLoader.readImage(file: self.currentFile) { _ in }
        }
        return self.currentFile
    }

    func goForwards() -> ImageFile {
        if (currentPosition + 1) < folder.files.count {
            currentPosition += 1
        } else {
            currentPosition = 0
        }
        self.currentFile = folder.files[currentPosition]
        withAnimation(.default) {
            ImageLoader.readImage(file: self.currentFile) { _ in }
        }
        return self.currentFile
    }

    func hasBackButton() -> Bool {
        return hasBackButtonVar
    }

    func hasNextButton() -> Bool {
        return hasNextButtonVar
    }

    func hasGoToButton() -> Bool {
        return hasGoToButtonVar
    }

    func hasSaveButton() -> Bool {
        return hasSaveButtonVar
    }

    func hasPlayPauseButton() -> Bool {
        return hasPlayPauseButtonVar
    }

    func getCurrentFile() -> ImageFile {
        return self.currentFile
    }

    func getCurrentFolder() -> ImageFolder {
        return folder
    }

    func setCurrentPosition(_ position: Int) {
        currentPosition = position
        self.currentFile = folder.files[currentPosition]
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
