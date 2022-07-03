//
//  Utility.swift
//  Movey Maint
//
//  Created by Gardner von Holt on 2016/Aug/22.
//  Copyright © 2016 Gardner von Holt. All rights reserved.
//

import Foundation

open class Utility: NSObject, URLSessionDelegate, URLSessionDownloadDelegate {
    static let sharedInstance = Utility()
    fileprivate  let protocolString = "http"

    open func callServer(_ command: String, subcommand: String, parameters: String,
                         errorHandler: @escaping (_ statusCode: Int, _ response: HTTPURLResponse?, _ error: Error?) -> Void,
                         completionHandler: @escaping (_ data: Data?) -> Void) {
        let requestURL = makeUrl(command, subcommand: subcommand, parameters: parameters)
        let datatask = URLSession.shared.dataTask(with: requestURL) { data, response, error in
            if response != nil {
                if let error = error {
                    print("error path")
                    self.handleClientError(error: error)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    self.handleServerError(response: response!)
                    print("server response \((response as? HTTPURLResponse)!.statusCode)")
                    return
                }
                let mimeType = httpResponse.mimeType
                if mimeType == "application/json" {
                    let data = data
                    completionHandler(data)
                } else if mimeType == "image/png" || mimeType == "image/jpeg" {
                    completionHandler(data)
                } else {
                    print("other response mime type '\(mimeType ?? "none")' from api server, response code '\(httpResponse.statusCode)'")
                    if data != nil {
                        let data = data
                        print(" Data: \(data!)")
                    }
                }
            }
        }
        datatask.resume()
    }

    private func handleClientError(error: Error) {
        print("Client error: \(error)")
    }

    private func handleServerError(response: URLResponse) {
        print("Server error: \(response)")
    }

    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let httpResponse = downloadTask.response as! HTTPURLResponse
        let statusCode = httpResponse.statusCode
        if statusCode < 200 || statusCode > 299 {
            print("Download failure: status \(statusCode)")
        }
    }

    public func makeUrl(_ command: String, subcommand: String, parameters: String?) -> URL {
        let urlString = makeUrlString(command, subcommand: subcommand, parameters: parameters)
        return URL(string: urlString)!
    }

    public func makeUrlString(_ command: String, subcommand: String, parameters: String?) -> String {
        let serverName = AppData.sharedInstance.serverName
        let serverPort = AppData.sharedInstance.serverPort
        let serverContext = AppData.sharedInstance.serverContext

        var baseUrl: String
        if serverContext.isEmpty {
            baseUrl = "\(protocolString)://\(serverName):\(serverPort)/api/1"
        } else {
            baseUrl = "\(protocolString)://\(serverName):\(serverPort)/\(serverContext)/api/1"
        }

        var fullUrl: String
        if subcommand.isEmpty {
            fullUrl = baseUrl + "/" + command
        } else {
            fullUrl = baseUrl + "/" + command + "/" + subcommand
        }

        if parameters != nil && !parameters!.isEmpty {
            fullUrl += "?"
            fullUrl += parameters!
        }
        return fullUrl
    }

    static func registerSettingsBundle() {
        var appDefaults = [String: AnyObject]()
        appDefaults["serverName_preference"] = "raspberrypi.local" as AnyObject
        appDefaults["serverPort_preference"] = "8080" as AnyObject
        appDefaults["serverContext_preference"] = "movey" as AnyObject
        UserDefaults.standard.register(defaults: appDefaults)
        UserDefaults.standard.synchronize()
    }

    static func updateFromDefaults() {
        // Get the defaults
        let defaults = UserDefaults.standard

        // Set the globals
        if let serverNamePreference = defaults.string(forKey: "serverName_preference") {
            AppData.sharedInstance.serverName = serverNamePreference
        } else {
            AppData.sharedInstance.serverName = ""
        }
        if let serverPortPreference = defaults.string(forKey: "serverPort_preference") {
            AppData.sharedInstance.serverPort = serverPortPreference
        } else {
            AppData.sharedInstance.serverPort = ""
        }
        if let serverContextPreference = defaults.string(forKey: "serverContext_preference") {
            AppData.sharedInstance.serverContext = serverContextPreference
        } else {
            AppData.sharedInstance.serverContext = ""
        }
    }

}
