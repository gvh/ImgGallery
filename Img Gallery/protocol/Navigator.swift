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
    func getRandomPosition() -> Int

    func getCurrentFilePosition() -> Int
    func getCurrentFile() -> ImageFile?

    func setCurrentFile(file: ImageFile)

    func doPrev()
    func doNext()

    func doSave()
    func doGoTo(file: ImageFile)

    func togglePlayPause()
}

protocol FolderNavigator {
    func doPrevResult()
    func doNextResult()
}
