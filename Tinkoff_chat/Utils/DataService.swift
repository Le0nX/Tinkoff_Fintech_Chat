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
    private init() {}

    private var conversations: [String: Conversation] = [:]

    private var onlineConversations = [Conversation]()
    private var offlineConversations = [Conversation]()

    func updateConversation(user: String, message: String, date: Date, history: Conversation.Message, hasUnread: Bool? ) {
        if let conversation = conversations[user] {
            if let unread = hasUnread {
                conversation.hasUnreadMessages = unread
            }

            conversation.history.append(history)
            conversation.date = date
            conversation.message = message
            updateOnlineConversations()
        }
    }

    func setOnline(id: String) -> Bool {
        if let conversation = conversations[id] {
            conversation.online = true
            updateOnlineConversations()
            return true
        } else {
            return false
        }
    }

    func setOffline(id: String) -> Bool {
        if let conversation = conversations[id] {
            conversation.online = false
            updateOfflineConversations()
            return true
        } else {
            return false
        }
    }

    func add(conversation: Conversation) {
        conversations[conversation.userId] = conversation
        onlineConversations = conversations.values.filter {$0.online}
//        offlineConversations = conversations.values.filter{!$0.online}
        updateOnlineConversations()
    }

    func remove(id: String) {
        conversations.removeValue(forKey: id)
        onlineConversations = conversations.values.filter {$0.online}
//        offlineConversations = conversations.values.filter{!$0.online}
        updateOnlineConversations()
    }

    func getAllConversations() -> [Conversation] {
        return Array(conversations.values)
    }

    func hasConversation(for userId: String) -> Bool {
        if conversations[userId] != nil {
            return true
        } else {
            return false
        }
    }

    func getOnlineConversations() -> [Conversation] {
        return onlineConversations
    }

    func getOfflineConversations() -> [Conversation] {
        return offlineConversations
    }

    private func updateOnlineConversations() {
        onlineConversations.sort(by: sortConversation(first:second:))
    }

    private func updateOfflineConversations() {
        offlineConversations.sort(by: sortConversation(first:second:))
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
