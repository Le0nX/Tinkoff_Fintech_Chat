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
    
    let serviceType = "serviceType"
    
    var sessions: [String: MCSession] = [:]
    
    var online: Bool = false {
        didSet {
            if online {
                // начинаем поиск и вещание
                advertiser.startAdvertisingPeer()
                browser.startBrowsingForPeers()
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
    
    //MARK: попытка сделать обновление имени у других пиров, если сменили имя профиля
//    func getCachedUserName() -> String {
//        // достаем имя из UserDefaults
//        return UserDefaults.standard.string(forKey: "user_name") ?? "NoName"
//    }
//
//    func restartAdvertiser() {
//        let userName = getCachedUserName()
//        let discoveryInfo = ["userName" : userName]
//
//        self.sessions.removeAll()
//        advertiser.stopAdvertisingPeer()
//        advertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: discoveryInfo, serviceType: serviceType)
//        advertiser.delegate = self
//        advertiser.startAdvertisingPeer()
//
//    }
//
//    func updateUserName() {
//        restartAdvertiser()
//    }
    
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
