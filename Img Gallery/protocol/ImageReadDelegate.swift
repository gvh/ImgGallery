//
//  ReadDelegate.swift
//  MediaBrowserMobile
//
//  Created by Gardner von Holt on 9/29/20.
//

import Foundation

protocol ImageReadDelegate: AnyObject {
    func onReadComplete(file: ImageFile)
}
