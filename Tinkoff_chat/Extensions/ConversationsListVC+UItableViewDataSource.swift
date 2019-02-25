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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Online"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    
    
}
