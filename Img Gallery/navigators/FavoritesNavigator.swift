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

    var currentPosition: Int

    init() {
        self.currentPosition = 0
        print("new favorites navigator: \(currentPosition)")
        readImageIfNeeded()
        self.configureImageDisplay()
        self.readImageIfNeeded()
    }

    func configureImageDisplay() {
        let file = getCurrentFile()
        guard file != nil else { return }
        AppData.sharedInstance.imageDisplay.setFile(file: file!)
    }

    func doPrev() {
        if AppData.sharedInstance.imageDisplay.hasBackButtonVar {
             currentPosition = currentPosition <= 0 ? AppData.sharedInstance.favorites.items.count - 1 : currentPosition - 1
            self.configureImageDisplay()
            readImageIfNeeded()
        }
    }

    func doNext() {
    if AppData.sharedInstance.imageDisplay.hasNextButtonVar {
        currentPosition = currentPosition >= AppData.sharedInstance.favorites.items.count - 1 ? currentPosition + 1 : 0
        self.configureImageDisplay()
        readImageIfNeeded()
        }
    }

    private func readImageIfNeeded() {
        let currentFile = getCurrentFile()

        guard currentFile != nil else { return }
        guard currentFile?.image == nil else { return }

//        withAnimation(.default) {
            ImageLoader.readImage(file: currentFile!) { file in
                AppData.sharedInstance.imageDisplay.updateImage(file: file)
            }
//        }
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
        readImageIfNeeded()
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

    func onSubscriptionTimer() {
    }

}
