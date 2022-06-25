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
    weak var delegate: DataLoaderDelegate?

    func create(completionHandler : @escaping (() -> Void) ) {
        DispatchQueue.global().async {
            self.load { (_ :ImageFolder?) in
                self.populate()
//                let countem = AppData.sharedInstance.downloadTOC.allFiles.count
//                print("count: \(countem)")
//                let appData = AppData.sharedInstance
                completionHandler()
            }
        }
    }

    func load(completionHandler : @escaping ((_ rootFolder: ImageFolder?) -> Void)) {
        let downloadInventory = InventoryReader()
        let baseURLString = AppData.sharedInstance.configInfo.baseURL
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
            self.scanAndRemoveIgnoredFolders()
            self.readDownloadIndex()
            completionHandler(rootFolder)
        }
    }

    func populate() {
        AppData.sharedInstance.downloadTOC.populateIndex()
        Favorites.loadCloud {
            Histories.loadCloud {
                AppData.sharedInstance.dataLoadComplete = true
                self.delegate?.onDataLoadComplete()
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

    func scanAndRemoveIgnoredFolders() {
        let folder = AppData.sharedInstance.downloadTOC.rootFolder
        if folder != nil {
            scanAndRemoveFolders(folder: folder!)
        }
    }

    func reduceFileCountRecurively(folder: ImageFolder?, count: Int, level: Int) {
        if folder == nil {
            return
        }
        if level > 100 {
            print("Infinite recursion reducing file count, stopped")
            return
        }
        folder?.filesInTree -= count
        let newLevel = level + 1
        reduceFileCountRecurively(folder: folder?.parentFolder, count: count, level: newLevel)
    }

    func scanAndRemoveFolders(folder: ImageFolder) {
        let ignorePhrases = AppData.sharedInstance.configInfo.ignoreFoldersContainingSet
        for ignorePhrase in ignorePhrases {
            let removeList = folder.subFolderKeys.filter({ $0.lowercased().contains(ignorePhrase) })
            for key in removeList {
                let removeIndex = folder.subFolderKeys.firstIndex(of: key)
                if removeIndex != nil {
                    let removeFolder: ImageFolder = folder.subFolders[key]!
                    reduceFileCountRecurively(folder: removeFolder.parentFolder, count: removeFolder.filesInTree, level: 0)
                    folder.subFolderKeys.remove(at: removeIndex!)
                }
                folder.subFolders.removeValue(forKey: key)
            }
        }

        for subFolder in folder.subFolders.values {
            scanAndRemoveFolders(folder: subFolder)
        }
    }
}
