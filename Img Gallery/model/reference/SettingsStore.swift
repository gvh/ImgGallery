//
//  SettingsStore.swift
//  Img Gallery
//
//  Created by Gardner von Holt on 6/30/22.
//  Copyright © 2022 Wvh. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

final class SettingsStore: ObservableObject {

    private enum Keys {

        static let labelAlignment = "LabelAlignment"

        static let ignoreFoldersContaining = "IgnoreFoldersContaining"
        static let secondsBetweenChanges = "SecondsBetweenChanges"
        static let secondsBetweenCountdown = "SecondsBetweenCountdown"

        static let userName = "UserName"
        static let passWord = "PassWord"
        static let baseURL = "BaseURL"
    }

    private let cancellable: Cancellable
    private let defaults: UserDefaults

    let objectWillChange = PassthroughSubject<Void, Never>()

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults

        defaults.register(defaults: [
            Keys.labelAlignment: 1,
            Keys.secondsBetweenChanges: 30,
            Keys.secondsBetweenCountdown: 10,
            Keys.ignoreFoldersContaining: "xxx",
            Keys.userName: "kittie",
            Keys.passWord: "boobies",
            Keys.baseURL: "https://bubis.kittycris.com/kittycris"
        ])

        cancellable = NotificationCenter.default
            .publisher(for: UserDefaults.didChangeNotification)
            .map { _ in () }
            .subscribe(objectWillChange)
    }

    public enum AlignmentChoice: String, CaseIterable {
        case topLeading
        case top
        case topTrailing
        case leading
        case center
        case trailing
        case bottomLeading
        case bottom
        case bottomTrailing
    }

    var alignment: AlignmentChoice {
        set {
            defaults.set(newValue.rawValue, forKey: Keys.labelAlignment)
        }
        get {
            return defaults.string(forKey: Keys.labelAlignment)
                .flatMap { AlignmentChoice(rawValue: $0) } ?? .topLeading
        }
    }

    var secondsBetweenChanges: Double {
        set { defaults.set(newValue, forKey: Keys.secondsBetweenChanges) }
        get { defaults.double(forKey: Keys.secondsBetweenChanges) }
    }

    var secondsBetweenCountdown: Double {
        set { defaults.set(newValue, forKey: Keys.secondsBetweenCountdown) }
        get { defaults.double(forKey: Keys.secondsBetweenCountdown) }
    }

    var ignoreFoldersContainingSet: Set<String> = Set<String>()
    var ignoreFoldersContaining: String {
        set {
            defaults.set(newValue, forKey: Keys.ignoreFoldersContaining)
            self.ignoreFoldersContainingSet.removeAll()
            let ignoreFoldersContainingWork = newValue.split(separator: " ")
            for ignoreFolderContaining in ignoreFoldersContainingWork {
                self.ignoreFoldersContainingSet.insert(String(ignoreFolderContaining.trimmingCharacters(in: .whitespaces)))
            }
        }
        get { defaults.string(forKey: Keys.ignoreFoldersContaining)! }
    }

    var userName: String {
        set { defaults.set(newValue, forKey: Keys.userName) }
        get { defaults.string(forKey: Keys.userName)! }
    }

    var passWord: String {
        set { defaults.set(newValue, forKey: Keys.passWord) }
        get { defaults.string(forKey: Keys.passWord)! }
    }

    var baseURL: String {
        set { defaults.set(newValue, forKey: Keys.baseURL) }
        get { defaults.string(forKey: Keys.baseURL)! }
    }

    func setServerReachable() {
            if AppData.sharedInstance.settingsStore.baseURL.isEmpty {
                AppData.sharedInstance.serverReachable = false
                AppData.sharedInstance.catalogDescription = ""
                return
            }
            AppData.sharedInstance.catalogDescription = ""
            let requestURL = getBaseUrlWithCredentials().appendingPathComponent("description.txt")
            let datatask = URLSession.shared.dataTask(with: requestURL) { data, response, error in
                if response != nil {
                    if error != nil {
                        print("error path")
                        AppData.sharedInstance.serverReachable = false
                        print("unable to read description URL")
                        AppData.sharedInstance.catalogDescription = ""
                        return
                    }
                    guard let httpResponse = response as? HTTPURLResponse,
                          (200...299).contains(httpResponse.statusCode) else {
                        print("server response \((response as? HTTPURLResponse)!.statusCode)")
                        AppData.sharedInstance.serverReachable = false
                        print("unable to read description URL")
                        AppData.sharedInstance.catalogDescription = ""
                        return
                    }
                    AppData.sharedInstance.catalogDescription = String(data:data!, encoding: .utf8) ?? ""
                    AppData.sharedInstance.serverReachable = true

                }
            }
            datatask.resume()


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

    static let alignments: [SettingsStore.AlignmentChoice: Alignment] = [.topLeading: .topLeading, .top: .top, .topTrailing: .topTrailing,
                                                                         .leading: .leading, .center: .center, .trailing: .trailing,
                                                                         .bottomLeading: .bottomLeading, .bottom: .bottom, .bottomTrailing: .bottomTrailing]

    static func alignmentDecode(alignmentChoice: SettingsStore.AlignmentChoice) -> Alignment {
        return SettingsStore.alignments[alignmentChoice] ?? .topLeading
    }

}
