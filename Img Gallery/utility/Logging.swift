//
//  Utility.swift
//  mediatransport
//
//  Created by Gardner von Holt on 2017/Nov/21.
//  Copyright © 2017 Gardner von Holt. All rights reserved.
//

import UIKit
import AVKit

class Logging: NSObject {

    static func showInternalError(message: String) {
        let errorMessage = "error.message".localizedWithComment(comment: "message in logging")
        print("\(errorMessage) : \(message)")
    }

}
