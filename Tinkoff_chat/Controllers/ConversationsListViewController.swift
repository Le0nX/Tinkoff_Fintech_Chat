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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        CommunicationManager.shared.delegate = self
        updateUsers()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ConversationSegue", let indexPath = sender as? IndexPath {
            let conversationViewController = segue.destination as! ConversationViewController // swiftlint:disable:this force_cast
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
        } else if segue.identifier == "ThemesSegue"{
            guard let themesNavigationVC = segue.destination as? UINavigationController, let themesVC = themesNavigationVC.viewControllers.first as? ThemesViewController else { return }
//            themesVC.delegate = self

            themesVC.changeThemeHandler = { (selectedTheme: UIColor) -> Void in
             UINavigationBar.appearance().barTintColor = selectedTheme

            /// save theme Data
            DispatchQueue.global(qos: .utility).async {
                 guard let themeData =  try? NSKeyedArchiver.archivedData(withRootObject: selectedTheme, requiringSecureCoding: false) else { return }
                 UserDefaults.standard.set(themeData, forKey: "SavedTheme")
            }
             StateLogger.shared.logThemeChanged(selectedTheme: selectedTheme)
             }

        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

    @IBAction func unwindToConversationsVC(unwindSegue: UIStoryboardSegue) {

    }
}
