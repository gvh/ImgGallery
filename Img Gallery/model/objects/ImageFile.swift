//
//  ImageFile.swift
//  mediatransport
//
//  Created by Gardner von Holt on 2016/Mar/29.
//  Copyright © 2016 Gardner von Holt. All rights reserved.
//

import ImageIO
import CoreServices
import CoreGraphics
import UIKit
import Photos
import CloudKit
import WvhExtensions

enum FileContents: Int {
    case image = 1
    case video = 2
}

final class ImageFile: ObservableObject {

    let id = UUID()

    static var defaultImage:UIImage = UIImage(systemName: "photo")!

    var parentFolder: ImageFolder
    private(set) var name: String
    private(set) var key: String

    @Published private(set) var image: UIImage
    private(set) var fileContents: FileContents
    private(set) var isDummyEntry: Bool = false
    @Published private(set) var imageReady = false

    var isFavorite: Bool = false
    var favorite: Favorite?
    var savedThisSession: Bool = false

    var favoriteID: String? {
        return favorite == nil ? nil : favorite?.favoriteID
    }

    func setSavedThisSession() {
        savedThisSession = true
    }

    static func create(name: String) -> ImageFile {
        let file: ImageFile = ImageFile(name: name)
        file.isDummyEntry = true
        return file
    }

    init(name: String) {
        self.name = name
        self.key = ""
        let folder = ImageFolder.createRoot(rootName: "xx")
        let folder2 = ImageFolder.create(folder: folder, name: "ccc")
        self.parentFolder = folder2
        self.fileContents = FileContents(rawValue: 1)!
        self.image = ImageFile.defaultImage
    }

    private init(name: String, key: String, parentFolder: ImageFolder, fileContents: FileContents) {
        self.name = name
        self.key = key
        self.parentFolder = parentFolder
        self.fileContents = fileContents
        self.image = ImageFile.defaultImage
    }

    static func create(key: String, rootFolder: ImageFolder) {
        let fileName: String = getFileNameFromKey(key)
        let fileContents: FileContents = fileName.endsWith(".mov") || fileName.endsWith("m4v") || fileName.endsWith(".mp4") ? .video : .image
        if fileContents == .image {
            let folder: ImageFolder = ImageFolder.findOrMake(folderPath: key, rootFolder: rootFolder)
            let fullKey: String = key
            let file: ImageFile = ImageFile(name: fileName, key: fullKey, parentFolder: folder, fileContents: fileContents)
            folder.addFile(file)
            AppData.sharedInstance.allFiles[file.id] = file
        }
    }

    static func getFileNameFromKey(_ key: String) -> String {
        var index = key.lastIndexOf("/")
        if index == nil {
            index = key.startIndex
        } else {
            index = key.index(index!, offsetBy: 1)
        }
        let fileName: String = index == nil ? key : String(key[index!...])
        return fileName
    }

    func setImage(_ image: UIImage) {
        self.image = image
        self.imageReady = true
        AppData.sharedInstance.imageReadDelegate?.onReadComplete(file: self)
    }

    var imageUrl: URL {
        let url = parentFolder.getURL().appendingPathComponent(name)
        return url
    }

    // See CGImageMetadataCopyTagWithPath documentation for an explanation
    let exifUserCommentPath = "\(kCGImageMetadataPrefixExif):\(kCGImagePropertyExifUserComment)" as CFString

    func writeJPEGFile(_ fileUrl: URL) -> Bool {
        if let data = image.jpegData(compressionQuality: 1.0) {
            try? data.write(to: fileUrl)
            return true
        }

        return false
    }

    func getFullPath() -> String {
        var parentPath = parentFolder.getFullPath()
        if parentPath.last != "/" {
            parentPath += "/"
        }
        parentPath += self.name
        return parentPath
    }

    func generateThumbnail(url: URL) {
        do {
            let asset = AVURLAsset(url: url)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 10, timescale: 1), actualTime: nil)
            let image = UIImage(cgImage: cgImage)
            setImage(image)
        } catch {
            let message = "generateThumbnail.createfailed".localizedWithComment(comment: "error in file access") + error.localizedDescription
            print(message)
        }
    }

    func getDisplayImage() {
        if !self.imageReady {
            ImageLoader.readImage(file: self) { _ in
            }
        }
    }

    static func remove(fileUrl: URL) {
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(at: fileUrl)
        } catch {
            let message = "cleartemp.createfailed".localizedWithComment(comment: "error in file access") + error.localizedDescription
            print(message)
        }
    }

    var parentParentFolder: ImageFolder? {
        return self.parentFolder.parentFolder
    }

    var parentPosition: Int {
        if parentParentFolder == nil {
            return 0
        } else {
            let position = self.parentParentFolder!.positionForFolder(folder: self.parentFolder) + 1
            return position
        }
    }

    var textDirectoryName: String {
        var folderName = self.parentParentFolder!.getFullPath()
        folderName = folderName.removeTrailing("/")
        folderName = folderName.removeLeading("/")
        return folderName
    }

    var textDirectorySequence: String {
        let ofWord = "of".localizedWithComment(comment: "label in file display")
        let foldersName = "folders".localizedWithComment(comment: "label in file display")
        return "\(String(describing: parentPosition)) \(ofWord) \(String(describing: parentParentSubFolderCount)) \(foldersName)"
    }

    var textFilePositionNumber: String {
        let positionForFile = self.parentFolder.positionForFile(file: self) + 1
        let filePositionString = "\(positionForFile)"
        return filePositionString
    }

    var textFilePosition: String {
        let positionForFile = self.parentFolder.positionForFile(file: self) + 1
        let ofWord = "of".localizedWithComment(comment: "label in file display")
        let fileCount = self.parentFolder.files.count
        let imagesText = "images".localizedWithComment(comment: "label in file display")
        let filePositionString = "\(positionForFile) \(ofWord) \(fileCount) \(imagesText)"
        return filePositionString
    }

    var parentParentSubFolderCount: Int {
        if parentParentFolder == nil {
            return 0
        } else {
            return parentParentFolder!.subFolderValues.count
        }
    }

    func getURLWithCredentials() -> URL {
        let url = parentFolder.getURL().appendingPathComponent(name)
        let urlString = url.absoluteString
        let endProtocol = urlString.indexOf("://")
        guard endProtocol != nil else { return url }
        let end1 = urlString.index(endProtocol!, offsetBy: 3)

        let string1 = String(urlString[..<end1])
        let string2 = String(urlString[end1...])

        let passwordString = string1 + AppData.sharedInstance.configInfo.username + ":" + AppData.sharedInstance.configInfo.password + "@" + string2
        return URL(string: passwordString)!
    }

    func getURL() -> URL {
        let url = parentFolder.getURL().appendingPathComponent(name)
        return url
    }
}

extension ImageFile: Equatable {

    static func == (lhs: ImageFile, rhs: ImageFile) -> Bool {
        return
            lhs.key == rhs.key &&
            lhs.name == rhs.name
    }

}

extension ImageFile: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(key)
        hasher.combine(name)
    }

}