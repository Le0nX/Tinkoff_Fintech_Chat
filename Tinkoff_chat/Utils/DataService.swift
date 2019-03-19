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
    
    var wasUpdated = true {
        didSet {
            if wasUpdated {
                onlineConversations = conversations.values.filter{$0.online}
                onlineConversations.sort(by: sortConversation(first:second:))
                wasUpdated = false
            } else {
                offlineConversations = conversations.values.filter{!$0.online && ($0.message != nil)}
            }
        }
    }
    private var conversations: [String : Conversation] = [:]
    
    private var onlineConversations = [Conversation]()
    private var offlineConversations = [Conversation]()
    
    func setOnline(id: String) -> Bool {
        if let conversation = conversations[id] {
            conversation.online = true
            wasUpdated = true
            return true
        } else {
            return false
        }
    }
    
    
    func setOffline(id: String) -> Bool {
        if let conversation = conversations[id] {
            conversation.online = false
            wasUpdated = true
            return true
        } else {
            return false
        }
    }
    
    func addFor(conversation: Conversation) {
        conversations[conversation.userId] = conversation
        wasUpdated = true
    }
    
    func remove(id: String) {
        conversations.removeValue(forKey: id)
        wasUpdated = true
    }
    
    func getConversations() -> [Conversation] {
        return Array(conversations.values)
    }
    
    func getConversations(userId: String) -> Conversation? {
        return conversations[userId]
    }
    
    func getOnlineConversations() -> [Conversation] {
        return onlineConversations
    }
    
    func getOfflineConversations() -> [Conversation] {
        return offlineConversations
    }
    
    private func sortConversation(first: Conversation, second: Conversation) -> Bool {
        if let firstDate = first.date, let firstName = first.name {
            if let secondDate = second.date, let secondName = first.name {
                if firstDate.timeIntervalSinceNow != secondDate.timeIntervalSinceNow {
                    return firstDate.timeIntervalSinceNow > secondDate.timeIntervalSinceNow
                }
                return firstName > secondName
            }
            return true
        } else {
            return false
        }
    }
}
