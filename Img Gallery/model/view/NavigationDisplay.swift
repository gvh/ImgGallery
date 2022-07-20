//
//  NavigationDisplay.swift
//  ImgGallery
//
//  Created by Gardner von Holt on 7/17/22.
//  Copyright © 2022 Wvh. All rights reserved.
//

import Foundation

class NavigationDisplay : ObservableObject {
    static var nextId: Int = 1
    var id: Int

    var hasResultButtons: Bool = false
    var hasBackButton: Bool = false
    var hasNextButton: Bool = false
    var hasSaveButton: Bool = false
    var hasGoToButton: Bool = false
    var hasPlayPauseButton: Bool = false

    init() {
        self.id = NavigationDisplay.nextId
        NavigationDisplay.nextId += 1
    }

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

extension NavigationDisplay : Identifiable {
}
