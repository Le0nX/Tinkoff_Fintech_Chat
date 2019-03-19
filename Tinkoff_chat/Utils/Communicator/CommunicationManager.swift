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
            DataService.shared.addFor(conversation: conversation)
            
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
        
    }
    
    func failedToStartAdvertising(error: Error) {
        
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        
        guard let delegate = delegate else { return }
        DispatchQueue.main.async {
            delegate.updateUsers()
        }
    }
    
    
}
