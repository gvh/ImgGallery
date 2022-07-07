//
//  Img_GalleryApp.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 6/23/22.
//

import SwiftUI

@main
struct Img_GalleryApp: App {
    let appData = AppData.sharedInstance

    init() {
        setup()
    }

    var body: some Scene {
        WindowGroup {
            ContentView(selectedTab: 1)
        }
    }
}

private extension Img_GalleryApp {
    func setup() {
        Utility.registerSettingsBundle()
        Utility.updateFromDefaults()

        //Configurator.configureLoad()
        AppData.sharedInstance.session = URLSessionFactory.create()
        AppData.sharedInstance.settingsStore.setServerReachable()
        Img_GalleryApp.configureData {
        }
    }

    static func configureData(completionHandler: @escaping () -> Void) {
        Img_GalleryApp.createRoots()
        CustomPhotoAlbum.sharedInstance.checkPhotoLibraryPermission()
        let dataLoader = DataLoader()
        dataLoader.create {
            completionHandler()
        }
    }

    static func createRoots() {
        let rootFolder = ImageFolder.createRoot(rootName: "download")
        AppData.sharedInstance.downloadTOC = TableOfContents(rootFolder: rootFolder)
    }
}
