//
//  ImageFolder.swift
//  mediatransport
//
//  Created by Gardner von Holt on 2016/Mar/29.
//  Copyright © 2016 Gardner von Holt. All rights reserved.
//

import Foundation
import SpriteKit
import SwiftUI

enum FolderContents: Int {
    case empty  = 0
    case onlyFiles = 1
    case onlyFolders = 2
    case bothFoldersAndFiles = 3
}

class ImageFolder: ObservableObject {
    private(set) var name: String

    private(set) var parentFolder: ImageFolder?

    @Published private(set) var subFolderValues: [ImageFolder] = []
    @Published private(set) var files: [ImageFile] = []

    private(set) var folderLevel: Int = 0
    private(set) var filesInTree: Int = 0

    private(set) var isRoot: Bool = false

    static let folderImage = UIImage(named: "folder.png")

    func getContentType() -> FolderContents {
        var contentCode: Int = 0
        if !subFolderValues.isEmpty { contentCode += 2 }
        if !files.isEmpty { contentCode += 1 }
        let folderContents = FolderContents.init(rawValue: contentCode)!
        return folderContents
    }

    private init(name: String, parentFolder: ImageFolder) {
        self.name = name
        self.parentFolder = parentFolder
    }

    private init(name: String) {
        self.name = name
    }

    static func createRoot(rootName: String) -> ImageFolder {
        let newFolder = ImageFolder(name: rootName)
        newFolder.parentFolder = nil
        newFolder.isRoot = true
        return newFolder
    }

    static func create(folder: ImageFolder?, name: String) -> ImageFolder {
        let index = name.lastIndexOf("/")
        let folderPath: String = index == nil ? name : String(name[index!...]) // name.substring(from: index!)
        let newFolder = ImageFolder(name: folderPath, parentFolder: folder! )
        folder?.addSubFolder(newFolder)
        AppData.sharedInstance.downloadAllFolders.append(newFolder)
        return newFolder
    }

    func positionForFolder(folder: ImageFolder) -> Int {
        var i: Int = 0
        for testFolder in subFolderValues {
            if testFolder.name == folder.name {
                return i
            }
            i += 1
        }
        return -1
    }

    func positionForFile(file: ImageFile) -> Int {
        var i: Int = 0
        for testFile in files {
            if testFile.name == file.name {
                return i
            }
            i += 1
        }
        return -1
    }

    fileprivate func addSubFolder(_ childFolder: ImageFolder) {
        childFolder.folderLevel = self.folderLevel + 1
        self.subFolderValues.append(childFolder)
        self.subFolderValues.sort()
    }

    func subFolder(_ key: String) -> ImageFolder? {
        let folders = subFolderValues.filter {$0.name == key}
        return folders.first
    }

    func addFile(_ file: ImageFile) {
        self.files.append(file)
        self.incrementCounter()
    }

    func incrementCounter() {
        self.filesInTree += 1
        if parentFolder != nil {
            parentFolder?.incrementCounter()
        }
    }

    func navigateTo(_ targetFolderName: String) -> ImageFolder {
        // ToDo: navigate to name
        var targetFullName = targetFolderName.beginsWith("/") ? targetFolderName : "/" + targetFolderName
        targetFullName = targetFullName.endsWith("/") ? targetFullName : targetFullName + "/"
        let selfFullName = self.getFullPath()

        if targetFullName == selfFullName {
            return self
        }

        if targetFullName.beginsWith(self.getFullPath()) {
            let firstMatching = subFolderValues.filter { targetFullName.beginsWith($0.getFullPath()) }.first
            return firstMatching!.navigateTo(targetFullName)
        }

        return self
    }

    static func find(folderPath: String, rootFolder: ImageFolder) -> ImageFolder? {
        var folder: ImageFolder? = rootFolder
        var parentFolder = folder

        let trimmedFolderPath = folderPath.removeLeading("/").removeTrailing("/")
        let folderNames: [String] = trimmedFolderPath.components(separatedBy: "/")

        for folderName in folderNames {
            folder = parentFolder!.subFolder(folderName)
            if folder == nil {
                return nil
            }
            parentFolder = folder
        }
        return folder
    }

    static func findOrMake(folderPath: String, rootFolder: ImageFolder) -> ImageFolder {
        var folder: ImageFolder? = rootFolder
        var parentFolder = folder

        let lastSlash = folderPath.lastIndexOf("/")

        // handle files in root directory
        if lastSlash == nil {
            return rootFolder
        }

        let folderPathOnly = String(folderPath[..<lastSlash!]) // folderPath.substring(to: lastSlash!)
        let folderNames: [String] = folderPathOnly.components(separatedBy: "/")

        for folderName in folderNames {
            folder = parentFolder!.subFolder(folderName)
            if folder == nil {
                folder = ImageFolder.create(folder: parentFolder, name: folderName)
            }
            parentFolder = folder
        }
        return folder!
    }

    func synchronized( _ lock: AnyObject, block: () -> Void ) {
        objc_sync_enter(lock)
        defer {
            objc_sync_exit(lock)
        }
        block()
    }

    func getName() -> String {
        return name
    }

    func getURL() -> URL {
        if parentFolder != nil {
            return (parentFolder?.getURL().appendingPathComponent(name))!
        } else {
            return URL(string: AppData.sharedInstance.settingsStore.baseURL)!.appendingPathComponent(name)
        }
    }

    func getURLWithCredentials() -> URL {
        if parentFolder != nil {
            return (parentFolder?.getURLWithCredentials().appendingPathComponent(name))!
        } else {
            return URL(string: AppData.sharedInstance.settingsStore.baseURL)!.appendingPathComponent(name)
        }
    }

    func imageForPosition(_ position: Int) -> UIImage? {
        let item = self.getFile(position)
        if item == nil {
            let image = UIImage(named: "default")!
            return image
        } else {
            return item?.image
        }
    }

    func getFile(_ position: Int) -> ImageFile? {
        if position >= 0 && position < files.count {
            return files[position]
        }
        return nil
    }

    func getImage() -> UIImage {
        let image = ImageFolder.folderImage ?? UIImage(systemName: "folder.fill")!
        return image
    }

    func getFile(name: String) -> ImageFile? {
        let file = files.filter { $0.name == name }
        return !file.isEmpty ? file[0] : nil
    }

    func getFullPath() -> String {
        let parentPath: String = parentFolder == nil ? "/" : ( (parentFolder?.getFullPath())! + name + "/")
        return parentPath
    }

    func getFile(atSequence: Int) -> ImageFile {
        var nextSequence = atSequence

        // first look in the files in this folder.  If the amount left is less than the number of fies
        // in this folder, select the file and return

        if nextSequence < self.files.count {
            let file = self.files[nextSequence]
            return file
        }

        // If we need to navigate the subdfolders, then we account for the files
        // in this folder before continuing

        nextSequence -= self.files.count

        for subFolder in self.subFolderValues {
            let filesInTree = subFolder.filesInTree

            if nextSequence < filesInTree {
                return subFolder.getFile(atSequence: nextSequence)
            }

            nextSequence -= filesInTree
        }

        let currentFolderName = self.getName()
        print("unable to find item \(nextSequence) in folder \(currentFolderName)")
        return ImageFile(name: "default")
    }

    func getFiles(beginsWith: String, endingWith: String) -> [ImageFile] {
        var files: [ImageFile] = []
        for file in self.files {
            if file.name.beginsWith(beginsWith) && file.name.endsWith(endingWith) {
                files.append(file)
            }
        }
        return files
    }

    private func removeFile(file: ImageFile) {
        guard let fileIndex = files.firstIndex(of: file) else { return }
        files.remove(at: fileIndex)
    }

    func getTokens() -> [String] {
        var tokenStrings: [String] = []
        var finalTokenStrings: [String] = []
        let tokens: [String.SubSequence] = name.split(separator: " ")
        for token in tokens where token.count > 2 {
            let tokenString = String(token).lowercased()
            tokenStrings.append(tokenString)
        }
        let uniqueTokenStrings = Array(Set(tokenStrings)).sorted()
        for uniqueTokenString in uniqueTokenStrings {
            finalTokenStrings.append(uniqueTokenString)
        }
        return finalTokenStrings
    }

    static func clearSearchCounts() {
    }

    var noPrefixName: String {
        if String(name[1]) == " " {
            return String(name[2...])
        } else {
            return name
        }
    }

    func reduceFileCountRecurively(count: Int, level: Int) {
        if level > 100 {
            print("Infinite recursion reducing file count, stopped")
            return
        }
        self.filesInTree -= count
        let newLevel = level + 1
        let higherFolder = self.parentFolder
        if higherFolder != nil {
            higherFolder!.reduceFileCountRecurively(count: count, level: newLevel)
        }
    }
}

extension ImageFolder: Identifiable {
}

extension ImageFolder: Comparable {
    static func < (lhs: ImageFolder, rhs: ImageFolder) -> Bool {
        return lhs.name.lowercased() < rhs.name.lowercased()
    }

    static func == (lhs: ImageFolder, rhs: ImageFolder) -> Bool {
        return lhs.name.caseInsensitiveCompare(rhs.name) == .orderedSame
    }
}
