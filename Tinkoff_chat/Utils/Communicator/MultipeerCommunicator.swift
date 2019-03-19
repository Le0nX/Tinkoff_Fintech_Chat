//
//  MultipeerCommunicator.swift
//  Tinkoff_chat
//
//  Created by Denis Nefedov on 17/03/2019.
//  Copyright © 2019 X. All rights reserved.
//

import MultipeerConnectivity

class MultipeerCommunicator: NSObject, Communicator {
    
    var myPeerID: MCPeerID!
    var browser: MCNearbyServiceBrowser!
    var advertiser: MCNearbyServiceAdvertiser!
    
    var sessions: [String: MCSession] = [:]
    
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
    
    // Используем weak, чтобы избежать retaincycle
    weak var delegate: CommunicatorDelegate?
    
    override init() {
        super.init()
        
        // достаем имя из UserDefaults
        let userName = UserDefaults.standard.string(forKey: "user_name") ?? "noname: (\(UIDevice.current.model))"
        
        let discoveryInfo = ["userName" : userName]
        let serviceType = "tinkoff-chat"
        
        myPeerID = MCPeerID(displayName: UIDevice.current.name)

        advertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: discoveryInfo, serviceType: serviceType)
        browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: serviceType)
        
        browser.delegate = self
        advertiser.delegate = self
        
        advertiser.startAdvertisingPeer()
        browser.startBrowsingForPeers()
    }
    
    
    func sendMessage(string: String, to userID: String, completionHandler: ((Bool, Error?) -> ())?) {
        guard let session = sessions[userID] else { return }
        
        let sendDict = ["eventType" : "TextMessage", "messageId" : generateMessageID(), "text" : string]
        
        guard let data = try? JSONSerialization.data(withJSONObject: sendDict, options: .prettyPrinted) else { return }
        do {
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
            delegate?.didReceiveMessage(text: string, fromUser: myPeerID.displayName, toUser: userID)
            if let completion = completionHandler {
                completion(true, nil)
            }
        } catch let error {
            if let completion = completionHandler {
                completion(false, error)
            }
        }
    }
    
    func getSession(with peerID: MCPeerID) -> MCSession {
        
        if let session = sessions[peerID.displayName] {
            return session
        }
        
        let session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .none)
        session.delegate = self
        sessions[peerID.displayName] = session
        return sessions[peerID.displayName]!
    }
    
    func generateMessageID() -> String {
        let string = "\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)+\(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString()
        return string!
    }
}
