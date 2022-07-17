//
//  NavigationDisplay.swift
//  ImgGallery
//
//  Created by Gardner von Holt on 7/17/22.
//  Copyright © 2022 Wvh. All rights reserved.
//

import Foundation

class NavigationDisplay : ObservableObject {
    var hasResultButtons: Bool = false
    var hasBackButton: Bool = false
    var hasNextButton: Bool = false
    var hasSaveButton: Bool = false
    var hasGoToButton: Bool = false
    var hasPlayPauseButton: Bool = false

    func configure(hasResultButtons: Bool, hasBackButton: Bool, hasNextButton: Bool, hasSaveButton: Bool, hasGoToButton: Bool, hasPlayPauseButton: Bool) {
        DispatchQueue.main.async {
            self.objectWillChange.send()
            self.hasResultButtons = hasResultButtons
            self.hasBackButton = hasBackButton
            self.hasNextButton = hasNextButton
            self.hasSaveButton = hasSaveButton
            self.hasGoToButton = hasGoToButton
            self.hasPlayPauseButton = hasPlayPauseButton
        }
    }
}
