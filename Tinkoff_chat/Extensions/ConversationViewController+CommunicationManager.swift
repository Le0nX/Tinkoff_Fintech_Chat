//
//  ConversationViewController+CommunicationManager.swift
//  Tinkoff_chat
//
//  Created by Denis Nefedov on 19/03/2019.
//  Copyright © 2019 X. All rights reserved.
//

import Foundation

extension ConversationViewController: CommunicationManagerDelegate {
    func updateUsers() {
        if !conversation.online {
            // MARK: затемнить кнопку 
            sendButton.isEnabled = false
        }
        conversation.hasUnreadMessages = false
        tableView.reloadData()
    }

    func handleError(error: Error) {
        self.view.endEditing(true)
        let alert = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
