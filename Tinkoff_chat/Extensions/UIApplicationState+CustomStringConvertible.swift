//
//  UIApplicationState+CustomStringConvertible.swift
//  Tinkoff_chat
//
//  Created by Denis Nefedov on 11/02/2019.
//  Copyright © 2019 X. All rights reserved.
//

import Foundation
import UIKit

/**
 Extension for UIApplication.State used in Logger.currentStateTransitionInfo()
 */
extension UIApplication.State: CustomStringConvertible {
    public var description: String {
        switch self {
        case .active:
            return("active")
        case .inactive:
            return("inactive")
        case .background:
            return("background")
        default:
            return("not running")
        }
    }
}
