//
//  MultipeerCommunicator.swift
//  Tinkoff_chat
//
//  Created by Denis Nefedov on 17/03/2019.
//  Copyright © 2019 X. All rights reserved.
//

import MultipeerConnectivity

class MultipeerCommunicator: NSObject, Communicator {
    
    
    var browser: MCNearbyServiceBrowser!
    var advertiser: MCNearbyServiceAdvertiser!
    
    func sendMessage(string: String, to userID: String, completionHandler: ((Bool, Error?) -> ())?) {
        <#code#>
    }
    
    // Используем weak, чтобы избежать retaincycle
    weak var delegate: CommunicatorDelegate?

    var online: Bool = true {
        didSet {
            if online {
                // начинаем поиск и вещание
                browser.startBrowsingForPeers()
                advertiser.startAdvertisingPeer()
            } else {
                // заканчиваем поиск и вещание
                browser.stopBrowsingForPeers()
                advertiser.stopAdvertisingPeer()
            }
        }
    }
    
    
}
