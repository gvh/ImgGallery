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

class FavoritesNavigator: Navigator, ObservableObject {
    var currentPosition: Int = 0

    func doPrev() {
        currentPosition = currentPosition <= 0 ? AppData.sharedInstance.favorites.items.count - 1 : currentPosition - 1
        setImageDisplay()
    }

    func doNext() {
        currentPosition = currentPosition >= AppData.sharedInstance.favorites.items.count - 1 ? currentPosition + 1 : 0
        setImageDisplay()
    }

    private func setImageDisplay() {
        let currentFile = getCurrentFile()
        guard currentFile != nil else { return }

        withAnimation(.default) {
            ImageLoader.readImage(file: currentFile!) { _ in }
        }
        AppData.sharedInstance.imageDisplay.setValues(name: currentFile!.textDirectoryName, image: currentFile!.image, directoryName: currentFile!.parentFolder.noPrefixName, fileSequence: currentPosition, fileCount: getTotalFiles())
    }

    func getTotalFiles() -> Int {
        return AppData.sharedInstance.favorites.items.count
    }

    func getCurrentFile() -> ImageFile? {
        return AppData.sharedInstance.favorites.items[currentPosition].file
    }

    func setCurrentFile(file: ImageFile) {
        currentPosition = AppData.sharedInstance.favorites.items.firstIndex (where: { $0.file == file } )!
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
    
}
