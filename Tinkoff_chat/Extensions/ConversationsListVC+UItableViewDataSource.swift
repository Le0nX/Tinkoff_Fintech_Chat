//
//  ConversationsListVC+UItableViewDataSource.swift
//  Tinkoff_chat
//
//  Created by Denis Nefedov on 25/02/2019.
//  Copyright © 2019 X. All rights reserved.
//

import Foundation
import UIKit

// The magic enum to end our pain and suffering!
// For the most part the order of our cases do not matter.
// What is important is that our first case is set to 0, and that our last case is always `total`.
enum TableSection: Int {
    case online = 0, history, total
}

extension ConversationsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let tableSection = TableSection(rawValue: section) {
            switch tableSection {
            case .online:
                return "Online"
            default:
                return "History"
            }
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tableSection = TableSection(rawValue: section) {
            switch tableSection {
            case .online:
                return dataService.getOnlineConversations().count
            default:
                return dataService.getOfflineConversations().count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath) as! ConversationCell
        let conversation: Conversation
        switch indexPath.section {
        case 0:
            conversation = dataService.getOnlineConversations()[indexPath.row]
        default:
            conversation = dataService.getOfflineConversations()[indexPath.row]
        }
        cell.name = conversation.name
        cell.message = conversation.message
        cell.date = conversation.date
        cell.hasUnreadMessages = conversation.hasUnreadMessages
        cell.online = conversation.online
        return cell
    }
    
    
}
