//
//  MultiPeerConnectionService.swift
//  QuizButton
//
//  Created by 手塚友健 on 2021/11/19.
//

import Foundation
import MultipeerConnectivity


protocol MultiPeerConnectionDelegate: AnyObject {
    func didReceiveHandler(sessionData: SessionData, fromPeer: MCPeerID) // データを受け取った後の処理
    func didChangeState(peerID: MCPeerID, state: MCSessionState) // 通信の状態が変化した後の処理
}


class MultiPeerConnectionService: NSObject {
    
    deinit {
        print("deinit: \(type(of: self))")
        browser.stopBrowsingForPeers()
        advertiser.stopAdvertisingPeer()
        session.disconnect()
    }
    
    let serviceType = "QuizButton"
    var session: MCSession!
    var advertiser: MCNearbyServiceAdvertiser!
    var browser: MCNearbyServiceBrowser!
    let peerID = MCPeerID(displayName: UIDevice.current.name)
    
    weak var delegate: MultiPeerConnectionDelegate?
    
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
        delegate?.didChangeState(peerID: peerID, state: state)
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let decoder = JSONDecoder()
        do {
            let sessionData = try decoder.decode(SessionData.self, from: data)
            guard let sessionType = SessionType(rawValue: sessionData.type) else {
                return
            }
            delegate?.didReceiveHandler(sessionData: sessionData, fromPeer: peerID)
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
    
    func sendData(_ sessionData: SessionData, toPeer: [MCPeerID]? = nil) {
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(sessionData)
            try session.send(jsonData, toPeers: toPeer ?? session.connectedPeers, with: .reliable)
        } catch {
            print(error.localizedDescription)
        }
    }
}
