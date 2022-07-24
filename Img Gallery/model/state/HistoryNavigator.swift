//
//  HistoryNavigator.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 7/3/22.
//  Copyright © 2022 Wvh. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class HistoryNavigator: FileNavigator, ObservableObject {


    var currentPosition: Int
    var lastRandomNumber: Int = -1

    init() {
        self.currentPosition = 0
        print("new history navigator: \(currentPosition)")
        self.readImageIfNeeded()
        self.configureImageDisplay()
        self.readImageIfNeeded()
    }

    func configureImageDisplay() {
        let file = getCurrentFile()
        guard file != nil else { return }
        AppData.sharedInstance.imageDisplay.configure(file: file!, fileSequence: currentPosition, fileCount: AppData.sharedInstance.histories.items.count)
        AppData.sharedInstance.imageDisplay.updateImage(file: file!)
    }

    func doPrevResult() {
    }

    func doNextResult() {
    }

    func doPrev() {
        currentPosition = currentPosition <= 0 ? AppData.sharedInstance.histories.items.count - 1 : currentPosition - 1
        self.configureImageDisplay()
    }

    func doNext() {
        currentPosition = currentPosition >= AppData.sharedInstance.histories.items.count - 1 ? 0 : currentPosition + 1
        self.configureImageDisplay()
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
        return AppData.sharedInstance.histories.items.count
    }

    func getCurrentFile() -> ImageFile? {
        guard AppData.sharedInstance.histories.items.count > 0 else { return nil }
        guard currentPosition >= 0 && currentPosition < AppData.sharedInstance.histories.items.count else { return nil }
        return AppData.sharedInstance.histories.items[currentPosition].file
    }

    func setCurrentFile(file: ImageFile) {
        currentPosition = AppData.sharedInstance.histories.items.firstIndex (where: { $0.file == file } )!
        let totalFiles = getTotalFiles()
        AppData.sharedInstance.imageDisplay.configure(file: file, fileSequence: currentPosition, fileCount: totalFiles)
        readImageIfNeeded()
    }

    func getCurrentFilePosition() -> Int {
        return currentPosition
    }

    func setCurrentFilePosition(position: Int) {
        currentPosition = position
        readImageIfNeeded()
    }

    func doGoTo(file: ImageFile) {
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
        if appData.imageDisplay.isTimerActive {
            Heartbeat.sharedInstance.stopTimer()
            appData.isTimerDesired = false
        } else {
            Heartbeat.sharedInstance.startTimer(delegate: self)
            appData.isTimerDesired = true
        }
    }

    func onImageChangeTimer() {
        currentPosition = getRandomPosition()
        self.configureImageDisplay()
        readImageIfNeeded()
    }

    func getRandomPosition() -> Int {
        let totalItems: Int = AppData.sharedInstance.histories.items.count
        guard totalItems > 0 else { return -1 }
        return Int.random(in: 0..<totalItems)
    }
}

extension HistoryNavigator : HeartbeatDelegate {

    func onBeat() {
        let position = self.getRandomPosition()
        let file = AppData.sharedInstance.histories.items[position].file
        setCurrentFile(file: file)
    }

}
