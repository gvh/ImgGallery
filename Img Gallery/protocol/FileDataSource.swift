//
//  FileDataSource.swift
//  MediaBrowser
//
//  Created by Gardner von Holt on 8/22/20.
//

import Foundation

protocol FileDataSource {

    func isRandom() -> Bool
    func getDisplayPositionDetails() -> (Int, Int)

    func onAppear()
    func onDisappear()

    func onSubscriptionTimer()
    func onProgress(timer: RefreshTimer)

    func hasBackButton() -> Bool
    func hasNextButton() -> Bool

    func hasGoToButton() -> Bool
    func hasPlayPauseButton() -> Bool

    func hasFullScreenButton() -> Bool

    func goBackwards() -> ImageFile

    func getRowCount() -> Int

    func getCurrentPosition() -> Int
    func setCurrentPosition(_ position: Int)

    func getCurrentFile() -> ImageFile
    func setCurrentFile(file: ImageFile)
    
    func getCurrentFolder() -> ImageFolder

    func getName() -> String
    func getFile(position: Int) -> ImageFile

    func getAllFiles() -> [ImageFile]

    func getTitle() -> String

    func doNext()
    func doPrev()

    func doSave(file: ImageFile)
    func togglePlayPause()

    func getScreenLabel(row: Int) -> String

    func setImageSelectionDelegate(delegate: ImageSelectionDelegate?)

    func getCurrentLocation() -> (Int, Int)

    func getRandomFile() -> ImageFile
    func getSequentialFile() -> ImageFile

    func getBasePath() -> String?

    func getDisplaySequenceLabel() -> String
}
