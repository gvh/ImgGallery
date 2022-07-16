//
//  Navigator.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 7/3/22.
//  Copyright © 2022 Wvh. All rights reserved.
//

import Foundation

protocol Navigator {
    func getTotalFiles() -> Int
    func doPrevResult()
    func doNextResult()
    func doPrev()
    func doNext()
    func doGoTo()
    func getCurrentFile() -> ImageFile?
    func setCurrentFile(file: ImageFile)
    func doSave()
    func togglePlayPause()
    func setButtons()
    func onSubscriptionTimer()
}
