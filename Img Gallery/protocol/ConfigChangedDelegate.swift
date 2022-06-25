//
//  ConfigChangedDelegate.swift
//  MediaBrowser
//
//  Created by Gardner von Holt on 1/31/22.
//

import Foundation

protocol ConfigChangedDelegate: AnyObject {
    func configurationDidChange()
}
