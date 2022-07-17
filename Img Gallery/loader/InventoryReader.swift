//
//  WvhInventory.swift
//  mediatransport
//
//  Created by Gardner von Holt on 2016/Oct/09.
//  Copyright © 2016 Gardner von Holt. All rights reserved.
//

import UIKit

class InventoryReader: NSObject {

    func readFromFileSystem(cachedDownloadURL: URL, rootFolder: ImageFolder) {
        self.processDownloadFile(url: cachedDownloadURL, rootFolder: rootFolder)
        return
    }

    func getInventory(url: URL, rootFolder: ImageFolder, completionHandler: @escaping ((_ rootFolder: ImageFolder) -> Void)) {
        let urlInternet = url.appendingPathExtension("txt")

        let cachedDownloadUrl = getCachedDownloadURL()
        let filePath = cachedDownloadUrl.path
        let fileManager = FileManager.default

        if fileManager.fileExists(atPath: filePath) {
            readFromFileSystem(cachedDownloadURL: cachedDownloadUrl, rootFolder: rootFolder)
            completionHandler(rootFolder)
        } else {
            HttpReader.copyInternetToFileSystem(fileManager: fileManager, sourceFilePath: urlInternet, targetFilePath: cachedDownloadUrl, rootFolder: rootFolder) {  newRootFolder in
                if fileManager.fileExists(atPath: filePath) {
                    self.readFromFileSystem(cachedDownloadURL: cachedDownloadUrl, rootFolder: newRootFolder!)
                    completionHandler(newRootFolder!)
                } else {
                    print("no file to re-read after first pass")
                    return
                }
            }
        }
    }

    func getCachedDownloadURL() -> URL {
        let fileManager = FileManager.default
        let paths = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        let url = paths[0]
        let urlReturn = url.appendingPathComponent("inventory.txt")
        return urlReturn
    }

    func processDownloadFile(url: URL, rootFolder: ImageFolder) {
        let stream = StreamReader(url: url)!
        var line = stream.nextLine()
        var fileCount: Int = 0
        if line != nil {
            while line != nil {
                fileCount += 1
                parseLine(line: line!, rootFolder: rootFolder)
                line = stream.nextLine()
            }
            print("startup complete")
        }
    }

    func parseLine(line: String, rootFolder: ImageFolder) {
        let indexStartOfText = line.index(line.startIndex, offsetBy: 2)
        if line.beginsWith("F") {
            let fileName = String(line[indexStartOfText...])
            ImageFile.create(key: fileName, rootFolder: rootFolder)
        } else if line.beginsWith("D") {
            let dirName = String(line[indexStartOfText...])
            _ = ImageFolder.findOrMake(folderPath: dirName, rootFolder: rootFolder)
        } else {
            print("Ignored unrecognized line: \(line)")
        }
        return
    }

}
