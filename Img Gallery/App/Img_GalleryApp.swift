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
            ContentView()
        }
    }
}


private extension Img_GalleryApp {
    func setup() {
        let consoleLogger = ConsoleLogger()
        AppData.sharedInstance.messageDisplayer = consoleLogger
        Utility.registerSettingsBundle()
        Utility.updateFromDefaults()

        Configurator.configureLoad()
        AppData.sharedInstance.session = URLSessionFactory.create()
        AppData.sharedInstance.configInfo.setServerReachable()
        Configurator.configureData {
            print("done with set server reachable")
        }
    }
}
