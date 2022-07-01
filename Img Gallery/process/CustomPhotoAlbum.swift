//
//  CustomPhotoAlbum.swift
//  WvhPhonePics
//
//  Created by Gardner von Holt on 12/13/15.
//  Copyright © 2015 Gardner von Holt. All rights reserved.
//

import Foundation
import Photos

open class CustomPhotoAlbum: NSObject {

    static let uniqueIdExif = kCGImagePropertyExifImageUniqueID

    static var sharedInstance: CustomPhotoAlbum = CustomPhotoAlbum()

    static let photoLibraryAlbumName = "photos.albumnName".localizedWithComment(comment: "photo album name")

    var albumName: String = CustomPhotoAlbum.photoLibraryAlbumName

    var assetCollection: PHAssetCollection?

    private func createAlbum() {

        if assetCollection == nil {
            if AppData.sharedInstance.photosAccess {
                let fetchOptions = PHFetchOptions()
                fetchOptions.predicate = NSPredicate(format: "title = %@", self.albumName)

                // error in next line in logs: [core] "Error returned from daemon: Error Domain=com.apple.accounts Code=7 "(null)""
                let collection: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)

                if let firstObject: AnyObject = collection.firstObject {
                    self.assetCollection = firstObject as? PHAssetCollection
                } else {
                    var assetCollectionPlaceholder: PHObjectPlaceholder?
                    PHPhotoLibrary.shared().performChanges({
                        let createAlbumRequest: PHAssetCollectionChangeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: self.albumName)
                        assetCollectionPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection
                    },
                    completionHandler: { success, _ in
                        if success {
                            let collectionFetchResult = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [assetCollectionPlaceholder!.localIdentifier], options: nil)
                            self.assetCollection = collectionFetchResult.firstObject!
                        }
                    })
                }
            } else {
                Logging.showInternalError(message: "photo.access.reason".localizedWithComment(comment: "photo access reason"))
            }
        }
    }

    func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .limited:
            print("photos already limited")
            AppData.sharedInstance.photosAccess = false

        case .authorized:
            AppData.sharedInstance.photosAccess = true
            createAlbum()

        case .denied, .restricted :
            print("photos already denied")
            AppData.sharedInstance.photosAccess = false

        case .notDetermined:
            // ask for permissions
            PHPhotoLibrary.requestAuthorization { status2 in
                switch status2 {
                case .authorized:
                    AppData.sharedInstance.photosAccess = true
                    self.createAlbum()

                case .denied, .restricted:
                    print("photos newly denied or restricted")
                    AppData.sharedInstance.photosAccess = false

                case .notDetermined, .limited:
                    print("photos newly undetermined or limited")
                    AppData.sharedInstance.photosAccess = false

                @unknown default:
                    AppData.sharedInstance.photosAccess = false

                }
            }

        @unknown default:
            print("photos already default")
            AppData.sharedInstance.photosAccess = false
        }
    }

    func saveImage(file: ImageFile, saveCompletionHandler: @escaping ((_ file: ImageFile) -> Void)) {
//        guard self.assetCollection != nil else {
//            Logging.showInternalError(message: "folder.not.found".localizedWithComment(comment: "folder not found message"))
//            return
//        }

        let directory = NSTemporaryDirectory()
        let fileName = directory + "/" + UUID().uuidString + ".jpg"

        let url = URL(fileURLWithPath: fileName)
        let success = file.writeJPEGFile(url)
        if success {
            PHPhotoLibrary.shared().performChanges({
                let assetRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: url)
                if assetRequest != nil {
                    let assetPlaceholder = assetRequest!.placeholderForCreatedAsset
                    let photosAsset: PHFetchResult = PHAsset.fetchAssets(in: self.assetCollection!, options: nil)
                    let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection!, assets: photosAsset)
                    let fastEnumeration = NSArray(array: [assetPlaceholder!] as [PHObjectPlaceholder])
                    albumChangeRequest!.addAssets(fastEnumeration)
                }
            },
            completionHandler: { success, _ in
                do {
                    if success {
                        try FileManager.default.removeItem(at: url)
                        saveCompletionHandler(file)
                        file.setSavedThisSession()
                    }
                } catch {
                    let removeTempFileFailed = "remove.tempfile.failed".localizedWithComment(comment: "message in photo album")
                    Logging.showInternalError(message: "\(removeTempFileFailed) : \(url.absoluteString)")
                }
            })
        } else {
            let writePngFailed = "write.png.failed".localizedWithComment(comment: "message in photo album")
            Logging.showInternalError(message: writePngFailed)
        }
    }

}
