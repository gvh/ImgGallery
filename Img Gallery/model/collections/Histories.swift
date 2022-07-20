//
//  FileHistory.swift
//  MediaBrowser
//
//  Created by Gardner von Holt on 8/5/20.
//

import Foundation
import CloudKit

class Histories: ObservableObject {

    var currentPosition: Int = -1
    var items: [History] = []

    static var ids: Set<Int> = []
    static var recordIDsToDelete: [CKRecord.ID] = []

    var atEnd: Bool {
        return currentPosition == (items.count - 1)
    }

    var atBeginning: Bool {
        return currentPosition == 0
    }

    var isEmpty: Bool {
        return items.isEmpty
    }

    func clear() {
        items.removeAll()
    }

    static func loadCloud(completionHandler : @escaping (() -> Void) ) {
        AppData.sharedInstance.histories.items.removeAll()
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "History", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["folderName", "fileName", "imageUrl", "creationDate"]
        operation.recordMatchedBlock = { (_, result) in
            switch result {
            case .success(let record):
                Histories.makeSuccess(record: record)
            case .failure(let error):
                print("error loading could with history: " + error.localizedDescription)
            }
        }
        operation.queryResultBlock = { _ in
            if !recordIDsToDelete.isEmpty {
                // clean up any duplicates removed during load
                print("removing a record from histories")
                Histories.remove(recordIDs: recordIDsToDelete)
            }
            print("completion handler from histories load")
            completionHandler()
        }
        AppData.sharedInstance.privateDb.add(operation)
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
                print("Would delete key \(key) ; recordid \(recordID) from histories")
                recordIDsToDelete.append(recordID)
            } else {
                DispatchQueue.main.async {
                    AppData.sharedInstance.histories.objectWillChange.send()
                    ids.insert(key)
                    let history = History(file: file!, dateAdded: dateAdded, historyID: recordID.recordName, record: record)
                    AppData.sharedInstance.histories.items.append(history)
                }
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
                let historyNotFound = "history.fileNotFound"
                print("\(historyNotFound) : \(folderName) + \(fileName)")
            }
        }
    }

    static func remove(recordIDs: [CKRecord.ID]) {
        for recordId in recordIDs {
            AppData.sharedInstance.privateDb.delete(withRecordID: recordId) { (recordId, err) in
                if let err = err {
                    print("Error in remove duplicates in history : \(err.localizedDescription)")
                    return
                }
                if recordId == nil {
                    print("Error in remove duplicates in history : missing recordId")
                    return
                }
            }
        }
    }

    func visit(file: ImageFile) {
        print("histories visit")
        let newHistory = History(file: file)
        if items.contains(newHistory) {

        } else {
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
            items.insert(newHistory, at: items.startIndex)
            currentPosition = items.count - 1
        }
        removeExcessHistory()
    }

    func updateAllUrls() {
        for history in items {
            history.dirty = true
            history.saveCloudRecord()
        }
    }

    private func removeExcessHistory() {
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
        if items.count > 225 {
            while items.count > 200 {
                let item = items.last
                item?.deleteCloudRecord()
                _ = items.removeLast()
            }
        }
    }

    func backward() -> ImageFile? {
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
        if items.isEmpty {
            currentPosition = -1
        }
        else if currentPosition >= items.count {
            currentPosition = items.count - 1
        }
        else if currentPosition < 0 {
            currentPosition = 0
        }

        else if currentPosition > 0 {
            currentPosition -= 1
        }
        return currentPosition < 0 ? nil : items[currentPosition].file
    }

    func forward() -> ImageFile? {
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
        if items.isEmpty {
            currentPosition = -1
        }
        else if currentPosition >= items.count {
            currentPosition = items.count - 1
        }
        else if currentPosition < 0 {
            currentPosition = 0
        }
        else if currentPosition < items.count - 1 {
            currentPosition += 1
        }
        return currentPosition < 0 ? nil : items[currentPosition].file
    }

    func save() {
        items.forEach { $0.saveCloudRecord() }
    }

}
