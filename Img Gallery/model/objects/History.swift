//
//  History.swift
//  MediaBrowserMobile
//
//  Created by Gardner von Holt on 10/15/20.
//

import Foundation
import CloudKit

class History {
    var file: ImageFile
    var dateAdded: Date
    var historyID: String
    var dirty: Bool

    var record: CKRecord?

    init(file: ImageFile, dateAdded: Date, historyID: String, record: CKRecord) {
        self.file = file
        self.dateAdded = dateAdded
        self.historyID = historyID
        self.record = record
        self.dirty = false
    }

    init(file: ImageFile) {
        self.file = file
        self.dateAdded = Date()
        self.dirty = true
        self.historyID = ""
    }

    func saveCloudRecord() {
        if self.dirty {
            if self.record == nil {
                self.record = CKRecord(recordType: "History")
                self.record!["fileName"] = file.name
                self.record!["folderName"] = file.parentFolder.name
            }

            let imageURLString = file.getURLWithCredentials().absoluteString
            self.record!["imageUrl"] = imageURLString
            let modifyRecords = CKModifyRecordsOperation(recordsToSave: [self.record!], recordIDsToDelete: nil)
            modifyRecords.savePolicy = CKModifyRecordsOperation.RecordSavePolicy.allKeys
            modifyRecords.qualityOfService = QualityOfService.userInitiated
            modifyRecords.modifyRecordsResultBlock = { result in
                switch result {
                case .success:
                    break
                case .failure(let error):
                    print("error saving history: " + error.localizedDescription)
                }
            }
            AppData.sharedInstance.privateDb.add(modifyRecords)
            self.dirty = false
        }
    }

    func deleteCloudRecord() {
        let id = CKRecord.ID(recordName: historyID)
        AppData.sharedInstance.privateDb.delete(withRecordID: id) { (_, _) in
        }
    }
}

extension History: Equatable {
    static func == (lhs: History, rhs: History) -> Bool {
        return
            lhs.file == rhs.file
    }
}

extension History: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(file)
    }
}
