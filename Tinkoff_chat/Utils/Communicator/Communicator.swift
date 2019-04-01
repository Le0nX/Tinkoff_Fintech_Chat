//
//  Communicator.swift
//  Tinkoff_chat
//
//  Created by Denis Nefedov on 17/03/2019.
//  Copyright © 2019 X. All rights reserved.
//

import Foundation

protocol Communicator {
    func sendMessage(string: String, to userID: String, completionHandler: ((_ success: Bool, _ error: Error?) -> Void)?)
    var delegate: CommunicatorDelegate? {get set}
    var online: Bool {get set}
}
