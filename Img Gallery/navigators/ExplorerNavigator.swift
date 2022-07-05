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
    var currentPosition: Int = 0

    init(currentFolder: ImageFolder, currentPosition: Int) {
        self.currentFolder = currentFolder
        self.currentPosition = currentPosition
        self.setImageDisplay()
    }

    func doPrev() {
        currentPosition = currentPosition <= 0 ? currentFolder.subFolderValues.count - 1 : currentPosition - 1
        setImageDisplay()
    }

    func doNext() {
        currentPosition = currentPosition >= currentFolder.subFolderValues.count - 1 ? currentPosition + 1 : 0
        setImageDisplay()
    }

    private func setImageDisplay() {
        let currentFile = getCurrentFile()
        guard currentFile != nil else { return }

        withAnimation(.default) {
            ImageLoader.readImage(file: currentFile!) { _ in }
        }
        AppData.sharedInstance.imageDisplay.navigator?.setCurrentFile(file: currentFile!)
//        AppData.sharedInstance.imageDisplay.setValues(name: currentFile!.textDirectoryName, image: currentFile!.image, directoryName: currentFile!.parentFolder.noPrefixName, fileSequence: currentPosition, fileCount: getTotalFiles())
    }

    func getTotalFiles() -> Int {
        return currentFolder.subFolderValues.count
    }

    func getCurrentFile() -> ImageFile? {
        return currentFolder.files[currentPosition]
    }

    func setCurrentFolder(currentFolder: ImageFolder) {
        self.currentFolder = currentFolder
    }

    func setCurrentFile(file: ImageFile) {
        currentPosition = currentFolder.files.firstIndex (where: { $0 == file } )!
        setImageDisplay()
    }

    func doSave() {
        let file = getCurrentFile()
        if file != nil {
            CustomPhotoAlbum.sharedInstance.saveImage(file: file!) { _ in
            }
        }
    }

    func togglePlayPause() {

    }

    func setButtons() {
        AppData.sharedInstance.imageDisplay.setButtons(hasBackButton: true, hasNextButton: true, hasSaveButton: true, hasGoToButton: false, hasPlayPauseButton: false)
    }
    
}
