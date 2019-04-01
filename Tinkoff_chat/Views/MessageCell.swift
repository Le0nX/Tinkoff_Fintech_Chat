//
//  ConversationCell.swift
//  Tinkoff_chat
//
//  Created by Denis Nefedov on 25/02/2019.
//  Copyright © 2019 X. All rights reserved.
//

import Foundation
import UIKit

class MessageCell: UITableViewCell, MessageCellConfiguration {

    @IBOutlet private var messageLbl: UILabel!

    var messageText: String? {
        didSet {
            messageLbl.text = messageText
            messageLbl.layer.cornerRadius = 5
            messageLbl.clipsToBounds = true
        }
    }

}
