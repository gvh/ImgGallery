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

class ExplorerNavigator: Navigator, ObservableObject {

    var currentFolder: ImageFolder
    var currentPosition: Int

    init(currentFolder: ImageFolder, currentPosition: Int) {
        self.currentFolder = currentFolder
        self.currentPosition = currentPosition
        print("new explorer navigator: \(currentFolder.noPrefixName) : \(currentPosition)")
        self.configureImageDisplay()
        self.readImageIfNeeded()
    }

    private func configureImageDisplay() {
        let file = getCurrentFile()
        guard file != nil else { return }
        AppData.sharedInstance.imageDisplay.configure(file: file!, fileSequence: currentPosition, fileCount: currentFolder.files.count)
    }

    func doPrevResult() {
    }

    func doNextResult() {
    }

    func doPrev() {
        if AppData.sharedInstance.navigationDisplay.hasBackButtonVar {
            currentPosition = currentPosition <= 0 ? currentFolder.files.count - 1 : currentPosition - 1
            self.configureImageDisplay()
            readImageIfNeeded()
        }
    }

    func doNext() {
        if AppData.sharedInstance.navigationDisplay.hasNextButtonVar {
            currentPosition = currentPosition >= currentFolder.files.count - 1 ? 0 : currentPosition + 1
            self.configureImageDisplay()
            readImageIfNeeded()
        }
    }

    func doGoTo() {
        print("do go to")
    }

    private func readImageIfNeeded() {
        let currentFile = getCurrentFile()

        guard currentFile != nil else { return }
        guard currentFile?.image == nil else { return }

        DispatchQueue.main.async {
            withAnimation(.default) {
                ImageLoader.readImage(file: currentFile!) { file in
                    AppData.sharedInstance.imageDisplay.updateImage(file: file)
                }
            }
        }
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
        DispatchQueue.main.async {
            self.currentPosition = self.currentFolder.files.firstIndex (where: { $0 == file } )!
            self.readImageIfNeeded()
        }
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
    }

    func setButtons() {
        DispatchQueue.main.async {
            AppData.sharedInstance.imageDisplay.setButtons(hasResultButtons: false, hasBackButton: true, hasNextButton: true, hasSaveButton: true, hasGoToButton: false, hasPlayPauseButton: false)
        }
    }

    func onSubscriptionTimer() {
    }
    
}
