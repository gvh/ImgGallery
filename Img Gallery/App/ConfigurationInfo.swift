//
//  ConfigInfo.swift
//  mediatransport
//
//  Created by Gardner von Holt on 8/30/15.
//  Copyright (c) 2015 Gardner von Holt. All rights reserved.
//

import Foundation

class ConfigurationInfo: NSObject {

    static let authorName = "MediaBrowser"

    private static let keyBasicAuthUser = "UserKey"
    private static let keyBasicAuthPassword = "PasswordKey"
    private static let keyBaseURL = "BaseURL"
    private static let keyIgnoreFoldersContaining = "IgnoreFoldersContaining"
    private static let keySecondsBetweenChanges = "SecondsBetweenChanges"
    private static let keyThumbnailsPerRow = "ThumbnailsPerRow"
    private static let keyCountdown = "Countdown"

    private static let userDefault = "kittie"
    private static let passwordDefault = "boobies"
    private static let baseURLDefault = "https://bubis.kittycris.com/kittycris"

    private static let ignoreFoldersContaingDefault = ""
    private static let secondsBetweenChangesDefault: Int = 15
    private static let thumbnailsPerRowDefault: Int = 251
    private static let countdownDefault: Int = 0

    var photosAccess: Bool = false

    var baseURL: String = ""
    var username: String = ""
    var password: String = ""

    var serverReachable: Bool = false

    var ignoreFoldersContainingString: String = ""
    var secondsBetweenChanges: Int = 15

    var thumbnailsPerRow: Int = 5

    var configValid: Bool = false

    var countdown: Int = 5
    var ignoreFoldersContainingSet: Set<String> = Set<String>()

    var configSaved: Bool = false

    private init (initUser: String, initPassword: String, initBaseURL: String, initIgnoreFoldersContaining: String,
                  initSecondsBetweenChanges: Int, initThumbnailsPerRow: Int, initCountdown: Int) {
        self.username = initUser
        self.password = initPassword
        self.baseURL = initBaseURL.removeTrailing("/")
        self.ignoreFoldersContainingString = initIgnoreFoldersContaining
        self.secondsBetweenChanges = initSecondsBetweenChanges
        self.thumbnailsPerRow = initThumbnailsPerRow
        self.configValid = true
        self.countdown = initCountdown
        self.ignoreFoldersContainingSet.removeAll()
        let ignoreFoldersContainingWork = self.ignoreFoldersContainingString.split(separator: " ")
        for ignoreFolderContaining in ignoreFoldersContainingWork {
            self.ignoreFoldersContainingSet.insert(String(ignoreFolderContaining.trimmingCharacters(in: .whitespaces)))
        }
        self.configSaved = true
        super.init()
    }

    func configFromParms(url: URL) {
        let urlComponents: URLComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        let command = urlComponents.path
        let host = urlComponents.host ?? ""
        let query = urlComponents.query ?? ""
        print("command: \(command) host: \(host) query: \(query)")
        if host == "config" {
            print("config recognized")
            let parameters = urlComponents.queryItems
            if parameters != nil {
                for parameter in parameters! {
                    switch parameter.name {
                    case "username":
                        self.username = parameter.value ?? ""
                        print("username set to '\(self.username)'")
                    case "password":
                        self.password = (parameter.value ?? "")
                        print("password set to '\(self.password)'")
                    case "url":
                        self.baseURL = (parameter.value ?? "").removeTrailing("/")
                        print("baseURL set to '\(self.baseURL)'")
                    default:
                        let parmName = parameter.name
                        let parmValue = parameter.value ?? ""
                        print("unknown parameter: \(parmName) with value \(parmValue)")
                    }
                }
                self.saveConfigInfoCloud()
            }
        }
    }

    func configureFromDefaults() {
        self.username = ConfigurationInfo.userDefault
        self.password = ConfigurationInfo.passwordDefault
        self.baseURL = ConfigurationInfo.baseURLDefault
        self.ignoreFoldersContainingString = ConfigurationInfo.ignoreFoldersContaingDefault
        self.secondsBetweenChanges = ConfigurationInfo.secondsBetweenChangesDefault
        self.thumbnailsPerRow = ConfigurationInfo.thumbnailsPerRowDefault
        self.countdown = ConfigurationInfo.countdownDefault
        self.ignoreFoldersContainingSet.removeAll()
        let ignoreFoldersContainingWork = self.ignoreFoldersContainingString.split(separator: " ")
        for ignoreFolderContaining in ignoreFoldersContainingWork {
            self.ignoreFoldersContainingSet.insert(String(ignoreFolderContaining.trimmingCharacters(in: .whitespaces)))
        }
        self.configValid = false
        self.serverReachable = false
    }

    static func loadFromICloud() -> ConfigurationInfo {
        let kvStore = NSUbiquitousKeyValueStore.default
        kvStore.synchronize()

        var initUser: String? = kvStore.string(forKey: keyBasicAuthUser)
        if initUser == nil || initUser!.isEmpty {
            initUser = userDefault
        }

        var initPassword: String? = kvStore.string(forKey: keyBasicAuthPassword)
        if initPassword == nil || initPassword!.isEmpty {
            initPassword = passwordDefault
        }

        var initBaseURL: String? = kvStore.string(forKey: keyBaseURL)
        if initBaseURL == nil || initBaseURL!.isEmpty {
            initBaseURL = baseURLDefault
        }
        if initBaseURL!.endsWith("/") {
            initBaseURL?.append(contentsOf: "/")
        }

        var initIgnoreFoldersContaining: String? = kvStore.string(forKey: keyIgnoreFoldersContaining)
        if initIgnoreFoldersContaining == nil {
            initIgnoreFoldersContaining = ignoreFoldersContaingDefault
        }

        var initSecondsBetweenChanges: Int? = Int(kvStore.longLong(forKey: keySecondsBetweenChanges))
        if initSecondsBetweenChanges == nil || initSecondsBetweenChanges! == 0 {
            initSecondsBetweenChanges = secondsBetweenChangesDefault
        }

        var initThumbnailsPerRow: Int? = Int(kvStore.longLong(forKey: keyThumbnailsPerRow))
        if initThumbnailsPerRow == nil || initThumbnailsPerRow! == 0 {
            initThumbnailsPerRow = thumbnailsPerRowDefault
        }

        let initCountdown: Int = Int(kvStore.longLong(forKey: keyCountdown))

        let configInfo = ConfigurationInfo(initUser: initUser!, initPassword: initPassword!, initBaseURL: initBaseURL!,
                                           initIgnoreFoldersContaining: initIgnoreFoldersContaining!,
                                           initSecondsBetweenChanges: initSecondsBetweenChanges!, initThumbnailsPerRow: initThumbnailsPerRow!,
                                           initCountdown: initCountdown)

        return configInfo
    }

    func saveConfigInfoCloud() {
        let kvStore = NSUbiquitousKeyValueStore.default
        kvStore.synchronize()
        kvStore.set(username, forKey: ConfigurationInfo.keyBasicAuthUser)
        kvStore.set(password, forKey: ConfigurationInfo.keyBasicAuthPassword)
        kvStore.set(baseURL, forKey: ConfigurationInfo.keyBaseURL)
        kvStore.set(ignoreFoldersContainingString, forKey: ConfigurationInfo.keyIgnoreFoldersContaining)
        kvStore.set(Int64(secondsBetweenChanges), forKey: ConfigurationInfo.keySecondsBetweenChanges)
        kvStore.set(Int64(thumbnailsPerRow), forKey: ConfigurationInfo.keyThumbnailsPerRow)
        kvStore.set(Int64(countdown), forKey: ConfigurationInfo.keyCountdown)
        kvStore.synchronize()
        self.configSaved = true
    }

    func setServerReachable() {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                if AppData.sharedInstance.configInfo.baseURL.isEmpty {
                    self.serverReachable = false
                    AppData.sharedInstance.catalogDescription = ""
                    return
                }
                AppData.sharedInstance.catalogDescription = ""
                let url = self.getBaseUrlWithCredentials().appendingPathComponent("description.txt")
                AppData.sharedInstance.catalogDescription = try String(contentsOf: url)
                self.serverReachable = true
            } catch {
                self.serverReachable = false
                print("unable to read description URL")
                AppData.sharedInstance.catalogDescription = ""
            }
        }
    }

    func getBaseUrlWithCredentials() -> URL {
        let url = URL(string: self.baseURL)
        let urlString = url!.absoluteString
        let endProtocol = urlString.indexOf("://")
        guard endProtocol != nil else { return url! }
        let end1 = urlString.index(endProtocol!, offsetBy: 3)

        let string1 = String(urlString[..<end1])
        let string2 = String(urlString[end1...])

        let passwordString = string1 + AppData.sharedInstance.configInfo.username + ":" + AppData.sharedInstance.configInfo.password + "@" + string2
        return URL(string: passwordString)!
    }

}
