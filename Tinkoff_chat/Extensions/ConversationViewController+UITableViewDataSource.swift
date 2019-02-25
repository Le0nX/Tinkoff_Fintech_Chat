//
//  ConversationViewController+UITableViewDataSource.swift
//  Tinkoff_chat
//
//  Created by Denis Nefedov on 25/02/2019.
//  Copyright © 2019 X. All rights reserved.
//

import Foundation
import UIKit

extension ConversationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messageCell: MessageCell
        switch conversation.history[indexPath.row] {
        case .income(let message):
            messageCell = tableView.dequeueReusableCell(withIdentifier: "MessageIncomeCell", for: indexPath) as! MessageCell
            messageCell.messageText = message
        case .outcome(let message):
            messageCell = tableView.dequeueReusableCell(withIdentifier: "MessageOutcomeCell", for: indexPath) as! MessageCell
            messageCell.messageText = message
        }
        return messageCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversation?.history.count ?? 0
    }
    
    
}
