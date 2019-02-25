//
//  ConversationCell.swift
//  Tinkoff_chat
//
//  Created by Denis Nefedov on 25/02/2019.
//  Copyright © 2019 X. All rights reserved.
//

import Foundation
import UIKit

class ConversationCell: UITableViewCell, ConversationCellConfiguration {
    
    @IBOutlet private var nameLbl: UILabel!
    @IBOutlet private var messageLbl: UILabel!
    @IBOutlet private var dateLbl: UILabel!
    
    var name: String? {
        didSet {
            nameLbl.text = name ?? "No name"
        }
    }
    
    var message: String? {
        didSet {
            if message == nil {
                messageLbl.font = UIFont(name: "Arial", size: 18)
            }
            messageLbl.text = message
        }
    }
    
    var date: Date? {
        didSet {
            guard let date = date else { return }
            
            let dateFormatter = DateFormatter()
            let calendar = Calendar.current
            
            if calendar.isDateInToday(date) {
                dateFormatter.dateFormat = "HH:mm"
            } else {
                dateFormatter.dateFormat = "dd MMM"
            }
            
            dateLbl.text = dateFormatter.string(from: date)
        }
    }
    
    var online: Bool = false {
        didSet {
            if online {
                backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            } else {
                backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }
        }
    }
    
    var hasUnreadMessages: Bool = false {
        didSet {
            guard let message = message else { return }
            if hasUnreadMessages {
                messageLbl.font = UIFont(name: "Futura-Bold", size:18)
            } else {
                messageLbl.font = UIFont(name: "Futura", size:18)
            }
            messageLbl.text = message
        }
    }
    
    
}
