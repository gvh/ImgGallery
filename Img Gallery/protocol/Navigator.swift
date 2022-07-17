//
//  Navigator.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 7/3/22.
//  Copyright © 2022 Wvh. All rights reserved.
//

import Foundation

protocol FileNavigator {

    func getTotalFiles() -> Int

    func getCurrentFilePosition() -> Int
    func setCurrentFilePosition(position: Int)

    func getCurrentFile() -> ImageFile?
    func setCurrentFile(file: ImageFile)

    func getRandomPosition() -> Int

    func doPrev()
    func doNext()

    func doGoTo(file: ImageFile)

// to app
    func togglePlayPause()
    func onSubscriptionTimer()

    // to file
    func doSave()
}

protocol FolderNavigator {
    func doPrevResult()
    func doNextResult()
}
