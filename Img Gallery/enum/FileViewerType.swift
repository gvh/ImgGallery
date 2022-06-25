//
//  FileViewerType.swift
//  MediaBrowser
//
//  Created by Gardner von Holt on 11/28/21.
//

import Foundation

enum FileViewerType: String {
    case menu
    case folder
    case favorite
    case history
    case keyword
    case search
    case random
    case sequential
}

enum FileSubViewerType: String {
    case folder
    case favorite
    case history
    case keyword
    case search
}
