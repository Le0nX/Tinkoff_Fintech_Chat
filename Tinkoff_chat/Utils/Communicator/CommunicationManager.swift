//
//  CommunicationManager.swift
//  Tinkoff_chat
//
//  Created by Denis Nefedov on 19/03/2019.
//  Copyright © 2019 X. All rights reserved.
//

import Foundation

class CommunicationManager: CommunicatorDelegate {
    
    var communicator: MultipeerCommunicator!
    
    // link to ViewControllers
    weak var delegate: CommunicationManagerDelegate?
    
    static let shared = CommunicationManager()
    private init() {
        self.communicator = MultipeerCommunicator()
        communicator.delegate = self
    }
    
    func didFoundUser(userID: String, userName: String?) {
        // refresh old user
        if !DataService.shared.setOnline(id: userID) {
            // adding new user
            let conversation = Conversation(userId: userID, name: userName)
            DataService.shared.add(conversation: conversation)
            
        }
        guard let delegate = delegate else { return }
        DispatchQueue.main.async {
            delegate.updateUsers()
        }
    }
    
    func didLostUser(userID: String) {
        if !DataService.shared.setOffline(id: userID) {
            // adding new user
            DataService.shared.remove(id: userID)
        }
        
        guard let delegate = delegate else { return }
        DispatchQueue.main.async {
            delegate.updateUsers()
        }
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        guard let delegate = delegate else { return }
        DispatchQueue.main.async {
            delegate.handleError(error: error)
        }
    }
    
    func failedToStartAdvertising(error: Error) {
        guard let delegate = delegate else { return }
        DispatchQueue.main.async {
            delegate.handleError(error: error)
        }
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        if let conversation = DataService.shared.getConversation(for: fromUser) {
            
            let message = Conversation.Message.income(text)
            conversation.history.append(message)
            
            conversation.date = Date()
            conversation.message = text
            conversation.hasUnreadMessages = true
            
            //TODO: исправить
            DataService.shared.wasUpdated = true
            
        } else if let conversation = DataService.shared.getConversation(for: toUser) {
            
            let message = Conversation.Message.outcome(text)
            conversation.history.append(message)
            
            conversation.date = Date()
            conversation.message = text
            
            //TODO: исправить
            DataService.shared.wasUpdated = true
        }
        
        guard let delegate = delegate else { return }
        DispatchQueue.main.async {
            delegate.updateUsers()
        }
    }
    
    
}
