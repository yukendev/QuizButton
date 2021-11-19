//
//  MultiPeerConnectionService.swift
//  QuizButton
//
//  Created by 手塚友健 on 2021/11/19.
//

import Foundation
import MultipeerConnectivity


protocol MultiPeerConnectionDelegate {
    func receiveHandler(sessionData: SessionData, fromPeer: MCPeerID)
}


class MultiPeerConnectionService: NSObject {
    
    let serviceType = "QuizButton"
    var session: MCSession!
    var advertiser: MCNearbyServiceAdvertiser!
    var browser: MCNearbyServiceBrowser!
    let peerID = MCPeerID(displayName: UIDevice.current.name)
    
    var delegate: MultiPeerConnectionDelegate?
    
    override init() {
        
        super.init()

        session = MCSession(peer: peerID)
        session.delegate = self
        
        advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceType)
        advertiser.delegate = self
        advertiser.startAdvertisingPeer()
        
        browser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)
        browser.delegate = self
        browser.startBrowsingForPeers()
    }
    
}


extension MultiPeerConnectionService: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .notConnected:
            print("\(peerID.displayName)が切断されました")
        case .connecting:
            print("\(peerID.displayName)が接続中です")
        case .connected:
            print("\(peerID.displayName)が接続されました")
        @unknown default:
            print("\(peerID.displayName)が想定外の状態です")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        // TODO: SessionTypeでswitchして処理
        let decoder = JSONDecoder()
        do {
            let sessionData = try decoder.decode(SessionData.self, from: data)
            guard let sessionType = SessionType(rawValue: sessionData.type) else {
                return
            }
            delegate?.receiveHandler(sessionData: sessionData, fromPeer: peerID)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("対応しない")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("対応しない")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        print("対応しない")
    }
}


extension MultiPeerConnectionService: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, session)
    }
}


extension MultiPeerConnectionService: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        guard let session = session else {
            return
        }
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 0)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("謎のばしょ")
    }
}


extension MultiPeerConnectionService {
    // 部屋番号の送信
    func sendRoomNumber(_ roomNumber: Int) {
        let data = String(roomNumber).data(using: .utf8)!
        let request = SessionData(type: SessionType.roomNumberRequest, data: data)
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(request)
            try session.send(jsonData, toPeers: session.connectedPeers, with: .reliable)
        } catch {
            print("Entrance: 部屋番号が送信できません")
//            print(error.localizedDescription)
        }
    }
}
