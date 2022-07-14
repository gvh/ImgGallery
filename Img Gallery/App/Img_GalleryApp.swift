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
        print("about to register settings bundle")
        Utility.registerSettingsBundle()
        print("about to update from defaults")
        Utility.updateFromDefaults()

        //Configurator.configureLoad()
        print("about to create session")
        AppData.sharedInstance.session = URLSessionFactory.create()
        print("about ro set server reachabke")
        AppData.sharedInstance.settingsStore.setServerReachable()
        print("about to configure data")
        Img_GalleryApp.configureData()
        print("img gallery setup complete")
    }

    static func configureData() {
        Img_GalleryApp.createRoots()
        CustomPhotoAlbum.sharedInstance.checkPhotoLibraryPermission()
        let dataLoader = DataLoader()
        dataLoader.create()
        print("data loader started")
    }

    static func createRoots() {
        let rootFolder = ImageFolder.createRoot(rootName: "download")
        AppData.sharedInstance.downloadTOC = TableOfContents(rootFolder: rootFolder)
    }
}
