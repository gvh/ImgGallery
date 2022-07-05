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

    @Published var name: String = ""
    @Published var image: UIImage = UIImage(systemName: "film")!

    @Published var parentDirectoryName: String = ""
    @Published var directoryName: String = ""
    @Published var fileSequence: Int = -1
    @Published var fileCount: Int = -2

    @Published var hasBackButtonVar: Bool = false
    @Published var hasNextButtonVar: Bool = false
    @Published var hasSaveButtonVar: Bool = false
    @Published var hasGoToButtonVar: Bool = false
    @Published var hasPlayPauseButtonVar: Bool = false

    @Published var countDownSeconds: Int = 0

    var navigator: Navigator?

    func setButtons(hasBackButton: Bool, hasNextButton: Bool, hasSaveButton: Bool, hasGoToButton: Bool, hasPlayPauseButton: Bool )  {
        self.hasBackButtonVar = hasBackButton
        self.hasNextButtonVar = hasNextButton
        self.hasSaveButtonVar = hasSaveButton
        self.hasGoToButtonVar = hasGoToButton
        self.hasPlayPauseButtonVar = hasPlayPauseButton
    }

    func setValues(name: String, image: UIImage, directoryName: String, fileSequence: Int, fileCount: Int) {
        self.name = name
        self.image = image
        self.directoryName = directoryName
        self.fileSequence = fileSequence
        self.fileCount = fileCount
    }

    func setFile(file: ImageFile) {
        self.name = file.name
        self.image = file.image
        self.directoryName = file.textDirectoryName
        self.fileSequence = file.subs
        navigator?.setCurrentFile(file: file)
    }

    func setNavigator(navigator: Navigator) {
        self.navigator = navigator
        self.navigator?.setButtons()
    }
}
