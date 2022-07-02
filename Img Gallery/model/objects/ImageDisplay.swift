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

    var fileDataSource: FileDataSource?

    func setValues(name: String, image: UIImage, parentDirectoryName: String, directoryName: String, fileSequence: Int, fileCount: Int, hasBackButton: Bool, hasNextButton: Bool, hasSaveButton: Bool, hasGoToButton: Bool, hasPlayPauseButton: Bool )  {
        self.name = name
        self.image = image
        self.parentDirectoryName = parentDirectoryName
        self.directoryName = directoryName
        self.fileSequence = fileSequence
        self.fileCount = fileCount
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

    func setDataSource(fileDataSource: FileDataSource) {
        self.fileDataSource = fileDataSource
    }
}
