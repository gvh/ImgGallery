//
//  MainMenu.swift
//  MediaBrowser
//
//  Created by Gardner von Holt on 1/17/21.
//

import Foundation

enum MenuChoice {
    case showFolder
    case showFavorites
    case showHistory
    case showKeyword
    case showSearch
    #if os(iOS)
    case showSetting
    #endif
}

public struct MainMenuItem: Hashable {
    var name: String
    var subtitle: String
    var target: MenuChoice
}
