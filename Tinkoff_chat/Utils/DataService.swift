//
//  DataService.swift
//  Tinkoff_chat
//
//  Created by Denis Nefedov on 25/02/2019.
//  Copyright © 2019 X. All rights reserved.
//

import Foundation

public class DataService {
    
    static let shared = DataService()
    private init(){}
    
    private let conversations: [Conversation] = [
        Conversation(name:"John Mcclane", message:"Hi", online: true, date: Date.from(year: 2018, month: 03, day: 13), hasUnreadMessages: true, history: [Conversation.Message.income("Ау"),Conversation.Message.income("Ауууу"),Conversation.Message.outcome("Привет")]),
        Conversation(name:"Lucy Armstrong", message:"Hi", online: false, date: Date.from(year: 2019, month: 02, day: 25), hasUnreadMessages: true, history: [Conversation.Message.income("Ау")]),
        Conversation(name:"John Mccarty", message:"Hi", online: true, date: Date.from(year: 2019, month: 02, day: 25), hasUnreadMessages: true, history: [Conversation.Message.income("Ау")]),
        Conversation(name:"Bob Dylan", message:"Hi", online: false, date: Date.from(year: 2019, month: 03, day: 13), hasUnreadMessages: true, history: [Conversation.Message.income("Ау")]),
        Conversation(name:"John Mccarty", message:"Hi", online: true, date: Date.from(year: 2017, month: 03, day: 13), hasUnreadMessages: true, history: [Conversation.Message.income("Ау")]),
        Conversation(name:"Katy Perry", message:"Hi", online: false, date: Date.from(year: 2019, month: 03, day: 13), hasUnreadMessages: true, history: [Conversation.Message.income("Ау")]),
    ]
    
    func getConversations() -> [Conversation] {
        return conversations
    }
    
    func getOnlineConversations() -> [Conversation] {
        return conversations.filter{$0.online}
    }
    
    func getOfflineConversations() -> [Conversation] {
        return conversations.filter{!$0.online && ($0.message != nil)}
    }
}
