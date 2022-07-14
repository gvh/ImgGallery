//
//  Favorite.swift
//  MediaBrowserMobile
//
//  Created by Gardner von Holt on 7/27/20.
//

import Foundation
import CloudKit
import Combine
import simd

final class Favorites: ObservableObject {

    let favoritesSizeLimit: Int = 1000

    @Published var items: [Favorite] = []
    @Published var currentPosition: Int = 0

    static var ids: Set<UUID> = []
    static var recordIDsToDelete: [CKRecord.ID] = []

    private enum CodingKeys: String, CodingKey {
        case itemStrings
    }

    func clear() {
        items.removeAll()
    }

    static func loadCloud(completionHandler : @escaping (() -> Void) ) {
        print("begin load cloud for favorites")
        AppData.sharedInstance.favorites.items.removeAll()
        print("after remove all for favorites")
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Favorite", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["folderName", "fileName", "creationDate"]
        operation.recordMatchedBlock = { (_, result) in
            make(result: result)
        }
        operation.queryResultBlock = { _ in
            print("about to clean up any duplicates removed during load")
            if !recordIDsToDelete.isEmpty {
                Favorites.remove(recordIDs: recordIDsToDelete)
            }

            print("end load cloud for favorites")
            completionHandler()
        }
        AppData.sharedInstance.privateDb.add(operation)
    }

    static func make(result: Result<CKRecord, Error>) {
        switch result {
        case .success(let record):
            Favorites.makeSuccess(record: record)
        case .failure(let error):
            Favorites.makeFailure(error: error)
        }
    }

    static func makeFailure(error: Error) {

    }

    static func makeSuccess(record: CKRecord) {
        let recordID = record.recordID
        let folderName: String = record["folderName"] as! String
        let folderNameLower: String = folderName.lowercased()
        let fileName: String = record["fileName"] as! String
        let dateAdded: Date = record.creationDate!
        let file: ImageFile? = AppData.sharedInstance.downloadTOC.getFileByKey(folderName: folderName, fileName: fileName)
        if file != nil {
            let key = file!.id
            if ids.contains(key) {
                print("Would delete recordid \(recordID) from favorites")
                // recordIDsToDelete.append(recordID)
            } else {
                ids.insert(key)
                let favorite = Favorite(file: file!, dateAdded: dateAdded, favoriteID: recordID.recordName)
                AppData.sharedInstance.favorites.add(favorite: favorite)
            }
        } else {
            var inIgnoreList: Bool = false
            AppData.sharedInstance.settingsStore.ignoreFoldersContainingSet.forEach({
                let token = $0.lowercased()
                if folderNameLower.contains(token) {
                    inIgnoreList = true
                }
            })
            if !inIgnoreList {
                let favoriteNotFound = "favorite.fileNotFound"
                print("\(favoriteNotFound) : \(folderName) + \(fileName)")
            }
        }
    }

    static func remove(recordIDs: [CKRecord.ID]) {
        for recordId in recordIDs {
            AppData.sharedInstance.privateDb.delete(withRecordID: recordId) { (recordId, err) in
                if let err = err {
                    print("Error in remove duplicates in favorites : \(err.localizedDescription)")
                    return
                }
                if recordId == nil {
                    print("Error in remove duplicates in favorites : missing recordId")
                    return
                }
            }
        }
    }

    func add(favorite: Favorite) {
        DispatchQueue.main.async {
            let file = favorite.file
            file.favorite = favorite
            file.isFavorite = true
            self.items.insert(favorite, at: self.items.startIndex)
            if self.items.count > self.favoritesSizeLimit {
                self.resize()
            }
            favorite.saveCloudRecord()
        }
    }

    func remove(favorite: Favorite) {
        let file = favorite.file
        file.favorite = nil
        file.isFavorite = false
        let itemIndex = self.items.firstIndex(of: favorite)!
        self.items.remove(at: itemIndex)
        favorite.deleteCloudRecord()
    }

    func getCurrentPosition() -> Int {
        return currentPosition
    }

    func resize() {
        while self.items.count > favoritesSizeLimit {
            self.items.remove(at: 0)
        }
    }

    func item(at: Int) -> Favorite? {
        return at > items.count || at < 0 ? nil : items[at]
    }

    var count: Int {
        return items.count
    }
}
