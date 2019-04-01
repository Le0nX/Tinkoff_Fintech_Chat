//
//  MessageCellConfiguration.swift
//  Tinkoff_chat
//
//  Created by Denis Nefedov on 25/02/2019.
//  Copyright © 2019 X. All rights reserved.
//

import Foundation

protocol MessageCellConfiguration: class {
    // changed name due to "Unavailable var 'text' was used to satisfy a requirement of protocol" error
    var messageText: String? {get set}
}
