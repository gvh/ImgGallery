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

    var imageDisplay = ImageDisplay()
    var folderDisplay = FolderDisplay()
    var navigationDisplay = NavigationDisplay()

//    var fileNavigator: FileNavigator?
    var folderNavigator: FolderNavigator?

    var serverName: String = ""
    var serverPort: String = ""
    var serverContext: String = ""
    
    var session: URLSession?

    var catalogDescription: String = ""
    var storyboard: UIStoryboard!

    var photosAccess: Bool = false
    var downloadTOC: TableOfContents!
    var downloadAllFolders: [ImageFolder] = []

    var keywordIndex: KeywordIndex = KeywordIndex()

    var favorites: Favorites = Favorites()

    var histories: Histories = Histories()

    var privateDb: CKDatabase!

    let isIPhone: Bool = UIDevice.current.userInterfaceIdiom == .phone
    let isTV: Bool = UIDevice.current.userInterfaceIdiom == .tv

    var settingsStore = SettingsStore()

    var isConfigured: Bool {
        return settingsStore.userName.isNotEmpty && settingsStore.passWord.isNotEmpty && settingsStore.baseURL.isNotEmpty
    }

    var serverReachable: Bool = false
    
    static let themeColor = UIColor(red: 27.0/255.0, green: 65.0/255.0, blue: 93.0/255.0, alpha: 1.0)

    var timer: Heartbeat = Heartbeat()

    var isTimerDesired: Bool = false
    var wasTimerActive: Bool = false

    var firstTimeStart: Bool = true

    var splitViewController: UISplitViewController!

    var dataLoadComplete: Bool = false

    init() {
        self.privateDb = CKContainer(identifier: "iCloud.com.gardnervh.MediaBrowser").privateCloudDatabase
        print("cloud db initialized")
    }



    func setFileNavigator() {

    }
}
