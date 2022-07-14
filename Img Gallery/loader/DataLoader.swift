//
//  LoadData.swift
//  mediatransport
//
//  Created by Gardner von Holt on 7/11/19.
//  Copyright © 2019 Gardner von Holt. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class DataLoader {
    func create() {
        print("data loader create")
        DispatchQueue.global().sync {
            self.load { (_ :ImageFolder?) in
                print("loaded")
                self.populate()
                print("populated")
            }
        }
    }

    func load(completionHandler : @escaping ((_ rootFolder: ImageFolder?) -> Void)) {
        let downloadInventory = InventoryReader()
        let baseURLString = AppData.sharedInstance.settingsStore.baseURL
        let rootName = AppData.sharedInstance.downloadTOC.rootFolder.getName()
        guard baseURLString.isNotEmpty && rootName.isNotEmpty else {
            print("error building download URL")
            return
        }
        let baseURL = URL(string: baseURLString)
        guard baseURL != nil else {
            print("error converting url from string to url")
            return
        }

        let downloadURL = makeURL(baseURL!, rootName)
        downloadInventory.getInventory(url: downloadURL, rootFolder: AppData.sharedInstance.downloadTOC.rootFolder) { (rootFolder) in
//            self.scanAndRemoveIgnoredFolders()
            self.sortAllFolders()
            self.readDownloadIndex()
            completionHandler(rootFolder)
        }
    }

    func sortAllFolders() {
        for idx in AppData.sharedInstance.downloadAllFolders.indices {
            let folder = AppData.sharedInstance.downloadAllFolders[idx]
//             folder.files.sort { $0.name < $1.name }
            if folder.files.count > 0 {
                let maxSubs = folder.files.count - 1
                for i in 0...maxSubs {
                    folder.files[i].subs = i
                }
            }
        }
    }

    func populate() {
        print("start populate index")
        AppData.sharedInstance.downloadTOC.populateIndex()
        print("populate index complete")
        Favorites.loadCloud {
            print("\(AppData.sharedInstance.favorites.items.count) favorites added")
            Histories.loadCloud {
                print("\(AppData.sharedInstance.histories.items.count) histories added")
                AppData.sharedInstance.dataLoadComplete = true
            }
        }
    }

    func makeURL(_ url: URL, _ folder: String) -> URL {
        let url2 = url.appendingPathComponent(folder)
        return url2
    }

    func readDownloadIndex() {
        AppData.sharedInstance.keywordIndex = KeywordIndex.load(folder: AppData.sharedInstance.downloadTOC.rootFolder)
    }
/*
    func scanAndRemoveIgnoredFolders() {
        let folder = AppData.sharedInstance.downloadTOC.rootFolder
        folder?.scanAndRemoveFolders()
    }
*/
}
