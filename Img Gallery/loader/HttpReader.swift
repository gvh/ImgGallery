//
//  HttpReader.swift
//  MediaBrowserMobile
//
//  Created by Gardner von Holt on 10/11/20.
//

import Foundation

class HttpReader {
    static func copyInternetToFileSystem(fileManager: FileManager,
                                         sourceFilePath: URL,
                                         targetFilePath: URL,
                                         rootFolder: ImageFolder,
                                         completionHandler: @escaping ((_ rootFolder: ImageFolder?) -> Void) ) {
        let session = AppData.sharedInstance.session
        guard session != nil else {
            print("no session to read with")
            return
        }

        let task = session!.downloadTask(with: sourceFilePath) { localURL, _, error in
            if let localURL = localURL {
                do {
                    try fileManager.copyItem(at: localURL, to: targetFilePath)
                    completionHandler(rootFolder)
                } catch {
                    print("cannot copy item at \(sourceFilePath) to \(targetFilePath) : \(error)")
                }
            }
        }
        task.resume()
    }
}
