//
//  Conversation.swift
//  Tinkoff_chat
//
//  Created by Denis Nefedov on 25/02/2019.
//  Copyright © 2019 X. All rights reserved.
//

import Foundation

struct Conversation {
    
    var name: String?
    var message: String?
    var online: Bool
    var date: Date?
    var hasUnreadMessages: Bool
    var history: [Message]
    
    
    enum Message {
        case income(String)
        case outcome(String)
    }
}
