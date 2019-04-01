//
//  ConversationListVC+CommunicationManager.swift
//  Tinkoff_chat
//
//  Created by Denis Nefedov on 19/03/2019.
//  Copyright © 2019 X. All rights reserved.
//

import Foundation

extension ConversationsListViewController: CommunicationManagerDelegate {
    func updateUsers() {
        tableView.reloadData()
    }

    func handleError(error: Error) {
        assert(false, error.localizedDescription)
    }
}
