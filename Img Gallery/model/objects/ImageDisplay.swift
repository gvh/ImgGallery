//
//  ImageDisplay.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 6/28/22.
//  Copyright © 2022 Wvh. All rights reserved.
//

import Foundation
import SwiftUI

class ImageDisplay : ObservableObject {
    var currentFile: ImageFile!
    var navigator: Navigator?

    var name: String = ""
    var image: UIImage = UIImage(systemName: "film")!

    var parentDirectoryName: String = ""
    var directoryName: String = ""
    var fileSequence: Int = -1
    var fileCount: Int = -2

    var hasBackButtonVar: Bool = false
    var hasNextButtonVar: Bool = false
    var hasSaveButtonVar: Bool = false
    var hasGoToButtonVar: Bool = false
    var hasPlayPauseButtonVar: Bool = false

    var isTimerActive: Bool = false
    var countDownSeconds: Int = 0

    func setButtons(hasBackButton: Bool, hasNextButton: Bool, hasSaveButton: Bool, hasGoToButton: Bool, hasPlayPauseButton: Bool )  {
        DispatchQueue.main.async {
            self.objectWillChange.send()
            self.hasBackButtonVar = hasBackButton
            self.hasNextButtonVar = hasNextButton
            self.hasSaveButtonVar = hasSaveButton
            self.hasGoToButtonVar = hasGoToButton
            self.hasPlayPauseButtonVar = hasPlayPauseButton
        }
    }

    func setValues(name: String, image: UIImage, directoryName: String, fileSequence: Int, fileCount: Int) {
        DispatchQueue.main.async {
            self.objectWillChange.send()
            self.name = name
            self.image = image
            self.directoryName = directoryName
            self.fileSequence = fileSequence
            self.fileCount = fileCount
        }
    }

    func setNavigator(navigator: Navigator) {
        self.navigator = navigator
        self.navigator?.setButtons()
    }

    func setFile(file: ImageFile) {
        DispatchQueue.main.async {
            self.objectWillChange.send()
            self.fileSequence = file.subs
            self.name = file.name
            self.image = file.image
            self.fileCount = file.parentFolder.files.count
            self.directoryName = file.parentFolder.noPrefixName
            self.parentDirectoryName = file.parentFolder.parentFolder?.getFullPath() ?? ""
            self.currentFile = file
        }
    }

    func updateImage(file: ImageFile) {
        if self.currentFile == file {
            DispatchQueue.main.async {
                self.objectWillChange.send()
                self.image = file.image
            }
        }
    }
}
