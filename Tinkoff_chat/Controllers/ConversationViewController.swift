//
//  ConversationViewController.swift
//  Tinkoff_chat
//
//  Created by Denis Nefedov on 25/02/2019.
//  Copyright © 2019 X. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {

    @IBOutlet private var tableView: UITableView! {
        didSet {
        /// трюк, чтобы UITableView не отрисовывал пустые ячейки, после того, как отрисовал все нужные ячейки
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        }
    }
    var conversation: Conversation!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        CommunicationManager.shared.delegate = self
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = conversation.name ?? "No name"
    }

}
