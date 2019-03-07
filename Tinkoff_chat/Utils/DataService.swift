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
        Conversation(name:"John Mcclane", message:"Hello", online: true, date: Date.from(year: 2018, month: 03, day: 13, hour: 22, minute: 12), hasUnreadMessages: true, history: [Conversation.Message.income("Hello, my friend! How are you???Hello, my friend! How are you???Hello, my friend! How are you???Hello, my friend! How are you???Hello, my friend! How are you???"),Conversation.Message.income("Ауууу"),Conversation.Message.outcome("Привет! У меня все ок!Привет! У меня все ок!Привет! У меня все ок!Привет! У меня все ок!Привет! У меня все ок!Привет! У меня все ок!Привет! У меня все ок!Привет! У меня все ок!Привет! У меня все ок!Привет! У меня все ок!"),Conversation.Message.income("Hello")]),
        
        Conversation(name:"John Mcclane", message:"Hello", online: true, date: Date.from(year: 2019, month: 02, day: 25, hour: 22, minute: 12), hasUnreadMessages: true, history: [Conversation.Message.income("Hello, my friend! How are you???Hello, my friend! How are you???Hello, my friend! How are you???Hello, my friend! How are you???Hello, my friend! How are you???"),Conversation.Message.income("Ауууу"),Conversation.Message.outcome("Привет! У меня все ок!Привет! У меня все ок!Привет! У меня все ок!Привет! У меня все ок!Привет! У меня все ок!Привет! У меня все ок!Привет! У меня все ок!Привет! У меня все ок!Привет! У меня все ок!Привет! У меня все ок!"),Conversation.Message.income("Hello")]),
        
        Conversation(name:"Lucy Armstrong", message:"Heeeeey", online: false, date: Date.from(year: 2019, month: 02, day: 25, hour: 12, minute: 35), hasUnreadMessages: false, history: [Conversation.Message.income("Heeeeey")]),
        
        Conversation(name:"Lucy Jamerson", message:"Oh my god!", online: true, date: Date.from(year: 2019, month: 02, day: 25, hour: 12, minute: 35), hasUnreadMessages: false, history: [Conversation.Message.income("Oh my god!")]),
        
        Conversation(name:"Narta Huley", message:"Whats up?", online: false, date: Date.from(year: 2019, month: 02, day: 25, hour: 11, minute: 34), hasUnreadMessages: true, history: [Conversation.Message.income("Whats up?")]),
        Conversation(name:"Jane Jane", message:"Yooooooo!", online: false, date: Date.from(year: 2019, month: 02, day: 25, hour: 23, minute: 23), hasUnreadMessages: false, history: [Conversation.Message.income("Yooooooo!"),Conversation.Message.income("Ауууу"),Conversation.Message.outcome("Привет")]),
        Conversation(name:"Peter Locky", message: nil, online: true, date: Date.from(year: 2019, month: 02, day: 25, hour: nil, minute: nil), hasUnreadMessages: true, history: []),
        Conversation(name:"Archy Linus", message:"Man, are you here?", online: true, date: Date.from(year: 2018, month: 02, day: 25, hour: nil, minute: nil), hasUnreadMessages: true, history: [Conversation.Message.income("Man, are you here?")]),
        Conversation(name:"Naman Ble", message: nil, online: true, date: Date.from(year: 2019, month: 02, day: 25, hour: nil, minute: nil), hasUnreadMessages: false, history: []),
        Conversation(name:"George Polman", message:"Hi", online: true, date: Date.from(year: 2019, month: 02, day: 25, hour: 11, minute: 45), hasUnreadMessages: false, history: [Conversation.Message.income("Hi"), Conversation.Message.outcome("Hello")]),
        Conversation(name:"Vlad Gang", message:"Hi", online: false, date: Date.from(year: 2018, month: 02, day: 25, hour: 01, minute: 23), hasUnreadMessages: false, history: [Conversation.Message.income("Hi")]),
        
    ]
    
    private var onlineConversations = [Conversation]()
    private var offlineConversations = [Conversation]()
    
    
    func getConversations() -> [Conversation] {
        return conversations
    }
    
    func getOnlineConversations() -> [Conversation] {
        if onlineConversations.count == 0 {
            onlineConversations = conversations.filter{$0.online}
        }
        return onlineConversations
    }
    
    func getOfflineConversations() -> [Conversation] {
        if offlineConversations.count == 0 {
            offlineConversations = conversations.filter{!$0.online && ($0.message != nil)}
        }
        return offlineConversations
    }
}
