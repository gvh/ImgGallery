//
//  Configurator.swift
//  MediaBrowserMobile
//
//  Created by Gardner von Holt on 11/4/20.
//

import UIKit

class Configurator {
    private static let downloadFolderName = "download"

    static func configureLoad() {
        AppData.sharedInstance.configInfo = ConfigurationInfo.loadFromICloud()
        AppData.sharedInstance.configInfo.saveConfigInfoCloud()
    }

    static func configureData(completionHandler: @escaping () -> Void) {
        createRoots()
        CustomPhotoAlbum.sharedInstance.checkPhotoLibraryPermission()
        let dataLoader = DataLoader()
        dataLoader.create {
            completionHandler()
        }
    }

    static func createRoots() {
        let rootFolder = ImageFolder.createRoot(rootName: Configurator.downloadFolderName)
        AppData.sharedInstance.downloadTOC = TableOfContents(rootFolder: rootFolder)
    }

}
