//
//  Favorite.swift
//  MediaBrowser
//
//  Created by Gardner von Holt on 8/8/20.
//

import Foundation
import CloudKit

class Favorite {
    var file: ImageFile
    var dateAdded: Date
    var favoriteID: String
    var dirty: Bool

    init(file: ImageFile, dateAdded: Date, favoriteID: String) {
        self.file = file
        self.dateAdded = dateAdded
        self.favoriteID = favoriteID
        self.dirty = false
        file.favorite = self
        file.isFavorite = true
    }

    init(file: ImageFile) {
        self.file = file
        self.dateAdded = Date()
        self.dirty = true
        self.favoriteID = ""
        file.favorite = self
        file.isFavorite = true
    }

    func saveCloudRecord() {
        if self.dirty {
            let favoriteRecord = CKRecord(recordType: "Favorite")
            self.favoriteID = favoriteRecord.recordID.recordName
            favoriteRecord["fileName"] = file.name
            favoriteRecord["folderName"] = file.parentFolder.name
            AppData.sharedInstance.privateDb.save(favoriteRecord) { (_, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                self.dirty = false
            }
        }
    }

    func deleteCloudRecord() {
        let id = CKRecord.ID(recordName: favoriteID)
        AppData.sharedInstance.privateDb.delete(withRecordID: id) { (_, _) in
        }
    }
}

extension Favorite: Equatable {
    static func == (lhs: Favorite, rhs: Favorite) -> Bool {
        return
            lhs.file == rhs.file
    }
}

extension Favorite: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(file)
    }
}
