//
//  AppData.swift
//  Movey Maint
//
//  Created by Gardner von Holt on 2016/Aug/14.
//  Copyright © 2016 Gardner von Holt. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

final class AppData {

    static var sharedInstance: AppData = AppData()

    var imageDisplay: ImageDisplay = ImageDisplay()

    var serverName: String = ""
    var serverPort: String = ""
    var serverContext: String = ""
    
    var session: URLSession?

    var catalogDescription: String = ""
    var storyboard: UIStoryboard!

    var configInfo: ConfigurationInfo!

    var downloadTOC: TableOfContents!
    var downloadAllFolders: [ImageFolder] = []

    var allFiles: [UUID: ImageFile] = [:]

    var keywordIndex: KeywordIndex = KeywordIndex()

    var favorites: Favorites = Favorites()

    var histories: Histories = Histories()

    var privateDb: CKDatabase!

    let isIPhone: Bool = UIDevice.current.userInterfaceIdiom == .phone
    let isTV: Bool = UIDevice.current.userInterfaceIdiom == .tv

    var isConfigured: Bool {
        guard configInfo != nil else { return false }

        return configInfo.username.isNotEmpty && configInfo.password.isNotEmpty && configInfo.baseURL.isNotEmpty
    }

    static let themeColor = UIColor(red: 27.0/255.0, green: 65.0/255.0, blue: 93.0/255.0, alpha: 1.0)

    weak var imageReadDelegate: ImageReadDelegate?
    var timer: RefreshTimer = RefreshTimer()

    var isTimerActive: Bool = false
    var isTimerDesired: Bool = false
    var wasTimerActive: Bool = false

    var wasDataSource: FileDataSource?
    var firstTimeStart: Bool = true

    var splitViewController: UISplitViewController!

    var dataLoadComplete: Bool = false

    var refreshDelegate: RefreshableDelegate?

    var messageDisplayer: MessageDisplayer = ConsoleLogger()

    init() {
        self.privateDb = CKContainer(identifier: "iCloud.com.gardnervh.imggallery").privateCloudDatabase
    }

    func startTimer(fileDataSource: FileDataSource) {
        timer.startTimer(viewer: fileDataSource)
        self.isTimerActive = true
    }

    func stopTimer() {
        timer.stopTimer()
        self.isTimerActive = false
    }

}
