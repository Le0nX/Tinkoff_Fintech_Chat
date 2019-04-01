//
//  MultipeerCommunicator+MC.swift
//  Tinkoff_chat
//
//  Created by Denis Nefedov on 17/03/2019.
//  Copyright © 2019 X. All rights reserved.
//

import MultipeerConnectivity

extension MultipeerCommunicator: MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate, MCSessionDelegate {

    // MARK: - MCNearbyServiceBrowserDelegate

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("⚠️\(#function)⚠️")
        sessions.removeValue(forKey: peerID.displayName)
        delegate?.didLostUser(userID: peerID.displayName)
    }

    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        print("✅\(#function)")
        guard let info = info, let userName = info["userName"] else { return }

        let session = getSession(with: peerID)
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
        delegate?.didFoundUser(userID: peerID.displayName, userName: userName)
    }

    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("⚠️\(#function)⚠️")
        delegate?.failedToStartBrowsingForUsers(error: error)
    }

    // MARK: - MCNearbyServiceAdvertiserDelegate

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("✅\(#function)")
        let session = getSession(with: peerID)
        invitationHandler(true, session)
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("⚠️\(#function)⚠️")
        delegate?.failedToStartAdvertising(error: error)
    }

    // MARK: - MCSessionDelegate

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .notConnected:
            print("⚠️\(peerID.displayName) is not connected")
        case .connecting:
            print("⚠️\(peerID.displayName) is connecting")
        case .connected:
            print("✅\(peerID.displayName) is connected")
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("✅\(#function)")
        let jsonDecoder = JSONDecoder()
        guard let info = try? jsonDecoder.decode([String: String].self, from: data), info["eventType"] == "TextMessage" else {return}
        delegate?.didReceiveMessage(text: info["text"]!, fromUser: peerID.displayName, toUser: myPeerID.displayName)
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("✅\(#function)")
    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("✅\(#function)")
    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {

    }

}
