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
    func doPrev()
    func doNext()
    func getCurrentFile() -> ImageFile?
    func setCurrentFile(file: ImageFile)
    func doSave()
    func togglePlayPause()
}
