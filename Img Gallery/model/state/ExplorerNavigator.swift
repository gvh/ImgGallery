//
//  ExplorerNavigator.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 7/3/22.
//  Copyright © 2022 Wvh. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class ExplorerNavigator: FileNavigator, ObservableObject {
    var currentFolder: ImageFolder
    var currentPosition: Int

    init(currentFolder: ImageFolder, currentPosition: Int) {
        self.currentFolder = currentFolder
        self.currentPosition = currentPosition
        print("new explorer navigator: \(currentFolder.noPrefixName) : \(currentPosition)")
        self.configureImageDisplay()
    }

    func configureImageDisplay() {
        let currentFile = getCurrentFile()
        guard currentFile != nil else { return }
        AppData.sharedInstance.imageDisplay.configure(file: currentFile!, fileSequence: currentPosition, fileCount: currentFolder.files.count)
        DispatchQueue.main.async {
            withAnimation(.default) {
                ImageLoader.readImage(file: currentFile!) { file in
                    AppData.sharedInstance.imageDisplay.updateImage()
                }
            }
        }
    }

    func doPrevResult() {
    }

    func doNextResult() {
    }

    func doPrev() {
        currentPosition = currentPosition <= 0 ? currentFolder.files.count - 1 : currentPosition - 1
        self.configureImageDisplay()
    }

    func doNext() {
        currentPosition = currentPosition >= currentFolder.files.count - 1 ? 0 : currentPosition + 1
        self.configureImageDisplay()
    }

    func doGoTo() {
        print("do go to")
    }

    func getTotalFiles() -> Int {
        return currentFolder.subFolderValues.count
    }

    func getCurrentFile() -> ImageFile? {
        guard currentFolder.files.count > 0 else { return nil }
        guard currentPosition >= 0 && currentPosition < currentFolder.files.count else { return nil }
        return currentFolder.files[currentPosition]
    }

    func setCurrentFolder(currentFolder: ImageFolder) {
        self.currentFolder = currentFolder
    }

    func setCurrentFile(file: ImageFile) {
        if self.currentFolder.files.count > 0 {
            DispatchQueue.main.async {
                self.currentPosition = self.currentFolder.files.firstIndex (where: { $0 == file } )!
                self.configureImageDisplay()
            }
        }
    }

    func getCurrentFilePosition() -> Int {
        return currentPosition
    }

    func setCurrentFilePosition(position: Int) {
        currentPosition = position
        self.configureImageDisplay()
    }

    func getRandomPosition() -> Int {
        let totalItems: Int = currentFolder.files.count
        guard totalItems > 0 else { return -1 }
        return Int.random(in: 0..<totalItems)
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
        if Heartbeat.sharedInstance.isTimerActive {
            Heartbeat.sharedInstance.stopTimer()
            appData.isTimerDesired = false
        } else {
            Heartbeat.sharedInstance.startTimer(delegate: self)
            appData.isTimerDesired = true
        }
    }

}

extension ExplorerNavigator : HeartbeatDelegate {

    func onBeat() {
        let position = self.getRandomPosition()
        let file = currentFolder.files[position]
        setCurrentFile(file: file)
    }

}
