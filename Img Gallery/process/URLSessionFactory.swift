//
//  URLSessionFactory.swift
//  MediaBrowser
//
//  Created by Gardner von Holt on 2/2/22.
//

import Foundation

class URLSessionFactory {

    static func create() -> URLSession {
        let config = URLSessionConfiguration.default
        let base64EncodedCredential = getLoginCredentials()
        let authString = "Basic \(base64EncodedCredential)"
        config.httpAdditionalHeaders = ["Authorization": authString]
        config.httpCookieAcceptPolicy = .always
        return URLSession(configuration: config)
    }

    private static func getLoginCredentials() -> String {
        let username: String = AppData.sharedInstance.settingsStore.userName
        let password: String = AppData.sharedInstance.settingsStore.passWord
        let userPasswordString = "\(username):\(password)"
        let userPasswordData = userPasswordString.data(using: String.Encoding.utf8, allowLossyConversion: false)

        let options: Data.Base64EncodingOptions = []
        let base64EncodedCredential = userPasswordData!.base64EncodedString(options: options)
        return base64EncodedCredential
    }
}
