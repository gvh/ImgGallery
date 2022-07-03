//
//  RandomFileViewer.swift
//  MediaBrowser
//
//  Created by Gardner von Holt on 9/12/20.
//

import Foundation
import SwiftUI
import Combine

class SequentialFileViewer {
    var file: ImageFile!
    var sequentialDataSource: FileDataSource
    weak var imageSelectionDelegate: ImageSelectionDelegate?
    var currentPosition: Int
    var rowCount: Int
    var needsInitialized: Bool
    let imageLoader = ImageLoader()

    init(sequentialDataSource: FileDataSource, imageSelectionDelegate: ImageSelectionDelegate?) {
        self.sequentialDataSource = sequentialDataSource
        self.imageSelectionDelegate = imageSelectionDelegate
        needsInitialized = true
        currentPosition = 0
        rowCount = sequentialDataSource.getCurrentFolder().filesInTree
    }

}

extension SequentialFileViewer: FileDataSource {

    func setCurrentFile(file: ImageFile) {
    }

   func getSequentialFile() -> ImageFile {
        sequentialDataSource.doNext()
        return sequentialDataSource.getCurrentFile()
    }

    func getAllFiles() -> [ImageFile] {
        return []
    }

    func isRandom() -> Bool {
        return true
    }

    func getDisplayPositionDetails() -> (Int, Int) {
        return (currentPosition + 1, rowCount)
    }

    func onAppear() {
        if needsInitialized {
            rowCount = sequentialDataSource.getCurrentFolder().filesInTree
            currentPosition = rowCount - 1
            file = goForwards()
            let file = sequentialDataSource.getCurrentFolder().getFile(atSequence: currentPosition)
            withAnimation(.default) {
                ImageLoader.readImage(file: file) { _ in }
            }
            imageSelectionDelegate?.onImageSelected()
            needsInitialized = false
        }

        if AppData.sharedInstance.firstTimeStart {
            AppData.sharedInstance.firstTimeStart = false
            AppData.sharedInstance.wasDataSource = self
            AppData.sharedInstance.startTimer(fileDataSource: self)
        }
    }

    func onDisappear() {
        AppData.sharedInstance.wasDataSource = nil
        AppData.sharedInstance.stopTimer()
    }

    func onSubscriptionTimer() {
        _ = goForwards()
    }

   func setImageSelectionDelegate(delegate: ImageSelectionDelegate?) {
        self.imageSelectionDelegate = delegate
    }

    func hasFullScreenButton() -> Bool {
        return true
    }

    func getScreenLabel(row: Int) -> String {
        let returnLabel = ""
        return returnLabel
    }

    func hasBackButton() -> Bool {
        return false
    }

    func hasNextButton() -> Bool {
        return true
    }

    func hasGoToButton() -> Bool {
        return true
    }

    func hasPlayPauseButton() -> Bool {
        return true
    }

    func goBackwards() -> ImageFile {
        return file!
    }

    func togglePlayPause() {
        let appData = AppData.sharedInstance
        if appData.isTimerActive {
            appData.wasDataSource = self
            appData.stopTimer()
            appData.isTimerDesired = false
        } else {
            appData.wasDataSource = nil
            appData.startTimer(fileDataSource: self)
            appData.isTimerDesired = true
        }

    }

    func doNext() {
        if AppData.sharedInstance.isTimerActive {
            AppData.sharedInstance.wasDataSource = nil
            AppData.sharedInstance.stopTimer()
            _ = goForwards()
            AppData.sharedInstance.wasDataSource = self
            AppData.sharedInstance.startTimer(fileDataSource: self)
        } else {
            _ = goForwards()
        }
    }

    func doPrev() {
    }

    func goForwards() -> ImageFile {
        if (currentPosition + 1) < rowCount {
            currentPosition += 1
        } else {
            currentPosition = 0
        }
        file = sequentialDataSource.getCurrentFolder().getFile(atSequence: currentPosition)
        withAnimation(.default) {
            ImageLoader.readImage(file: file) { _ in }
        }
        if file != nil {
            imageSelectionDelegate?.onImageSelected()
        }
        return file
    }

    func getRowCount() -> Int {
        return rowCount
    }

    func getCurrentPosition() -> Int {
        return currentPosition
    }

    func setCurrentPosition(_ position: Int) {
        if position >= 0 && position < rowCount {
            self.currentPosition = position
        }
    }

    func getCurrentFile() -> ImageFile {
        return file!
    }

    func getCurrentFolder() -> ImageFolder {
        let folder = getCurrentFile().parentFolder
        return folder
    }

    func getName() -> String {
        return "random.images".localizedWithComment(comment: "label in sequential file viewer")
    }

    func getFile(position: Int) -> ImageFile {
        return file!
    }

    func doSave(file: ImageFile) {
        CustomPhotoAlbum.sharedInstance.saveImage(file: file) { _ in
        }
    }

    func getBasePath() -> String? {
        return sequentialDataSource.getBasePath()
    }

    func getRandomFile() -> ImageFile {
        return sequentialDataSource.getRandomFile()
    }

    func getCurrentLocation() -> (Int, Int) {
        return sequentialDataSource.getCurrentLocation()
    }

    func getTitle() -> String {
        let baseTitle = sequentialDataSource.getTitle()
        let randomImagesLabel = "sequential.images".localizedWithComment(comment: "label in sequential file viewer")
        let fromWord = "from".localizedWithComment(comment: "label in sequential file viewer")
        return "\(randomImagesLabel) \(fromWord) \(baseTitle)"
    }

    func getDisplaySequenceLabel() -> String {
        return "sequentially".localizedWithComment(comment: "label in sequential file viewer")
    }
}
