//
//  FavoritesNavigator.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 7/3/22.
//  Copyright © 2022 Wvh. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class FavoritesNavigator: FileNavigator, ObservableObject {


    var currentPosition: Int
    var lastRandomNumber: Int = -1

    init() {
        self.currentPosition = 0
        print("new favorites navigator: \(currentPosition)")
        self.configureImageDisplay()
    }

    func configureImageDisplay() {
        let currentFile = getCurrentFile()
        guard currentFile != nil else { return }
        AppData.sharedInstance.imageDisplay.configure(file: currentFile!, fileSequence: currentPosition, fileCount: AppData.sharedInstance.favorites.items.count)

        guard currentFile?.image == nil else { return }

        withAnimation(.default) {
            ImageLoader.readImage(file: currentFile!) { file in
                print(currentFile!.getFullPath() + " read")
                AppData.sharedInstance.imageDisplay.updateImage()
            }
        }
    }

    func doPrevResult() {
    }

    func doNextResult() {
    }

    func doPrev() {
        currentPosition = currentPosition <= 0 ? AppData.sharedInstance.favorites.items.count - 1 : currentPosition - 1
        self.configureImageDisplay()
    }

    func doNext() {
        currentPosition = currentPosition >= AppData.sharedInstance.favorites.items.count - 1 ? 0 : currentPosition + 1
        self.configureImageDisplay()
    }

    func doGoTo() {
        print("do go to")
    }

    func getTotalFiles() -> Int {
        return AppData.sharedInstance.favorites.items.count
    }

    func getCurrentFile() -> ImageFile? {
        guard AppData.sharedInstance.favorites.items.count > 0 else { return nil }
        guard currentPosition >= 0 && currentPosition < AppData.sharedInstance.favorites.items.count else { return nil }

        return AppData.sharedInstance.favorites.items[currentPosition].file
    }

    func setCurrentFile(file: ImageFile) {
        currentPosition = AppData.sharedInstance.favorites.items.firstIndex (where: { $0.file == file } )!
        self.configureImageDisplay()
    }

    func getCurrentFilePosition() -> Int {
        return currentPosition
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

    func getRandomPosition() -> Int {
        let totalItems: Int = AppData.sharedInstance.favorites.items.count
        guard totalItems > 0 else { return -1 }
        return Int.random(in: 0..<totalItems)
    }
}

extension FavoritesNavigator : HeartbeatDelegate {

    func onBeat() {
        let position = self.getRandomPosition()
        let file = AppData.sharedInstance.favorites.items[position].file
        setCurrentFile(file: file)
    }

}
