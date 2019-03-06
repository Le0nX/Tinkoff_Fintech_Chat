//
//  ConversationsListViewController.swift
//  Tinkoff_chat
//
//  Created by Denis Nefedov on 25/02/2019.
//  Copyright © 2019 X. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController {

    let dataService = DataService.shared
    
    @IBOutlet internal var tableView: UITableView! {
        didSet {
            /// трюк, чтобы UITableView не отрисовывал пустые ячейки, после того, как отрисовал все нужные ячейки
            tableView.dataSource = self
            tableView.delegate = self
            tableView.tableFooterView = UIView()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ConversationSegue", let indexPath = sender as? IndexPath {
            let conversationViewController = segue.destination as! ConversationViewController
            let conversation: Conversation
            switch indexPath.section {
            case 0:
                conversation = dataService.getOnlineConversations()[indexPath.row]
            default:
                conversation = dataService.getOfflineConversations()[indexPath.row]
            }
            conversationViewController.conversation = conversation
            
            let backButton = UIBarButtonItem()
            backButton.title = ""
            navigationItem.backBarButtonItem = backButton
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    @IBAction func unwindToConversationsVC(unwindSegue: UIStoryboardSegue) {
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
