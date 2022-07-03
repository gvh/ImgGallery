//
//  RandomFileViewer.swift
//  MediaBrowser
//
//  Created by Gardner von Holt on 9/12/20.
//

import Foundation
import SwiftUI
import Combine

class RandomFileViewer {
    var file: ImageFile?
    var randomDataSource: FileDataSource
    var needsRandom: Bool = true

    let imageLoader = ImageLoader()

    init(randomDataSource: FileDataSource) {
        self.randomDataSource = randomDataSource
    }
}

extension RandomFileViewer: FileDataSource {

    func setCurrentFile(file: ImageFile) {
    }

    func getSequentialFile() -> ImageFile {
        return goForwards()
    }

    func getAllFiles() -> [ImageFile] {
        return []
    }

    func isRandom() -> Bool {
        return true
    }

    func getDisplayPositionDetails() -> (Int, Int) {
        return randomDataSource.getDisplayPositionDetails()
    }

    func onAppear() {
        if needsRandom {
            file = goForwards()
            needsRandom = false
        }

        if AppData.sharedInstance.firstTimeStart {
            AppData.sharedInstance.firstTimeStart = false
            AppData.sharedInstance.wasDataSource = self
            AppData.sharedInstance.startTimer(fileDataSource: self)
        } else {
            if AppData.sharedInstance.isTimerDesired {
                AppData.sharedInstance.startTimer(fileDataSource: self) ////////
            }
        }
    }

    func onDisappear() {
        AppData.sharedInstance.wasDataSource = nil
        AppData.sharedInstance.stopTimer()
    }

    func onSubscriptionTimer() {
        _ = goForwards()
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
        file = randomDataSource.getRandomFile()
        withAnimation(.default) {
            ImageLoader.readImage(file: file!) { _ in }
        }
        return file!
    }

    func getRowCount() -> Int {
        return -1
    }

    func getCurrentPosition() -> Int {
        return 0
    }

    func setCurrentPosition(_ position: Int) {
    }

    func getCurrentFile() -> ImageFile {
        return file!
    }

    func getCurrentFolder() -> ImageFolder {
        let folder = getCurrentFile().parentFolder
        return folder
    }

    func getName() -> String {
        return "random.images".localizedWithComment(comment: "label in Random File Viewer")
    }

    func getFile(position: Int) -> ImageFile {
        return file!
    }

    func doSave(file: ImageFile) {
        CustomPhotoAlbum.sharedInstance.saveImage(file: file) { _ in
        }
    }

    func getBasePath() -> String? {
        return randomDataSource.getBasePath()
    }

    func getRandomFile() -> ImageFile {
        return randomDataSource.getRandomFile()
    }

    func getTitle() -> String {
        let baseTitle = randomDataSource.getTitle()
        let randomImagesLabel = "random.images".localizedWithComment(comment: "label in random file viewer")
        let fromWord = "from".localizedWithComment(comment: "label in random file viewer")
        return "\(randomImagesLabel) \(fromWord) \(baseTitle)"
    }

    func getCurrentLocation() -> (Int, Int) {
        return randomDataSource.getCurrentLocation()
    }

    func getDisplaySequenceLabel() -> String {
        return "Randomly".localizedWithComment(comment: "label in random file viewer")
    }
}
