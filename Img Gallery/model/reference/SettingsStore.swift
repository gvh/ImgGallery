//
//  SettingsStore.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 6/30/22.
//  Copyright © 2022 Wvh. All rights reserved.
//

import Foundation
import Combine

final class SettingsStore: ObservableObject {
    private enum Keys {
        static let IgnoreFoldersContaining = "IgnoreFoldersContaining"
        static let SecondsBetweenChanges = "SecondsBetweenChanges"
        static let SecondsBetweenCountdown = "SecondsBetweenCountdown"
        static let UserName = "UserName"
        static let PassWord = "PassWord"
        static let BaseURL = "BaseURL"
    }

    private let cancellable: Cancellable
    private let defaults: UserDefaults

    let objectWillChange = PassthroughSubject<Void, Never>()

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults

        defaults.register(defaults: [
            Keys.SecondsBetweenChanges: "30",
            Keys.SecondsBetweenCountdown: "10",
            Keys.IgnoreFoldersContaining: "xxx",
            Keys.UserName: "kittie",
            Keys.PassWord: "boobies",
            Keys.BaseURL: "https://bubis.kittycris.com/kittycris"
        ])

        cancellable = NotificationCenter.default
            .publisher(for: UserDefaults.didChangeNotification)
            .map { _ in () }
            .subscribe(objectWillChange)
    }

    var secondsBetweenChanges: String {
        set { defaults.set(newValue, forKey: Keys.SecondsBetweenChanges) }
        get { defaults.string(forKey: Keys.SecondsBetweenChanges)! }
    }

    var secondsBetweenCountdown: String {
        set { defaults.set(newValue, forKey: Keys.SecondsBetweenCountdown) }
        get { defaults.string(forKey: Keys.SecondsBetweenCountdown)! }
    }

    var ignoreFoldersContainingSet: Set<String> = Set<String>()
    var ignoreFoldersContaining: String {
        set {
            defaults.set(newValue, forKey: Keys.IgnoreFoldersContaining)
            self.ignoreFoldersContainingSet.removeAll()
            let ignoreFoldersContainingWork = newValue.split(separator: " ")
            for ignoreFolderContaining in ignoreFoldersContainingWork {
                self.ignoreFoldersContainingSet.insert(String(ignoreFolderContaining.trimmingCharacters(in: .whitespaces)))
            }
        }
        get { defaults.string(forKey: Keys.IgnoreFoldersContaining)! }
    }

    var userName: String {
        set { defaults.set(newValue, forKey: Keys.UserName) }
        get { defaults.string(forKey: Keys.UserName)! }
    }

    var passWord: String {
        set { defaults.set(newValue, forKey: Keys.PassWord) }
        get { defaults.string(forKey: Keys.PassWord)! }
    }

    var baseURL: String {
        set { defaults.set(newValue, forKey: Keys.BaseURL) }
        get { defaults.string(forKey: Keys.BaseURL)! }
    }

    func setServerReachable() {
            if AppData.sharedInstance.settingsStore.baseURL.isEmpty {
                AppData.sharedInstance.serverReachable = false
                AppData.sharedInstance.catalogDescription = ""
                return
            }
            AppData.sharedInstance.catalogDescription = ""
            let url = getBaseUrlWithCredentials().appendingPathComponent("description.txt")
            DispatchQueue.global().sync {
                do {
                    AppData.sharedInstance.catalogDescription = try String(contentsOf: url)
                } catch {
                    AppData.sharedInstance.serverReachable = false
                    print("unable to read description URL")
                    AppData.sharedInstance.catalogDescription = ""
                }
            }
            AppData.sharedInstance.serverReachable = true
    }

    func getBaseUrlWithCredentials() -> URL {
        let url = URL(string: self.baseURL)
        let urlString = url!.absoluteString
        let endProtocol = urlString.indexOf("://")
        guard endProtocol != nil else { return url! }
        let end1 = urlString.index(endProtocol!, offsetBy: 3)

        let string1 = String(urlString[..<end1])
        let string2 = String(urlString[end1...])

        let passwordString = string1 + AppData.sharedInstance.settingsStore.userName + ":" + AppData.sharedInstance.settingsStore.passWord + "@" + string2
        return URL(string: passwordString)!
    }

}
