//
//  StandbyViewModel.swift
//  QuizButton
//
//  Created by 手塚友健 on 2021/11/10.
//

import Foundation
import RxCocoa
import RxSwift
import MultipeerConnectivity

class CreatingRoomViewModel: NSObject {
    
    let disposeBag = DisposeBag()
    
    private let serviceType = "QuizButton"
    private var session: MCSession!
    private var advertiser: MCNearbyServiceAdvertiser!
    private var browser: MCNearbyServiceBrowser!
    let peerID = MCPeerID(displayName: UIDevice.current.name)
    
    var roomNumber: Int
    
    init(roomNumber: Int) {
        
        self.roomNumber = roomNumber
        
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
    
    func sendResponse(response: RoomNumberRequest, peerID: MCPeerID) {
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(response)
            try session.send(jsonData, toPeers: [peerID], with: .reliable)
        } catch {
            print(error.localizedDescription)
        }
    }
}


extension CreatingRoomViewModel: MCSessionDelegate {
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
    
    // Data型を受け取った時
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let decoder = JSONDecoder()
        do {
            let request = try decoder.decode(RoomNumberRequest.self, from: data)
            print("from: \(request.id)\nroomNumber: \(request.roomNumber)\nrequestType: \(request.requestType)")
            if request.roomNumber == self.roomNumber {
                // 部屋番号が一致
                let approval = RoomNumberRequest(id: self.peerID.displayName, roomNumber: self.roomNumber, requestType: RequestType.approval)
                sendResponse(response: approval, peerID: peerID)
            } else {
                // 部屋番号が一致しない
                let reject = RoomNumberRequest(id: self.peerID.displayName, roomNumber: self.roomNumber, requestType: RequestType.reject)
                sendResponse(response: reject, peerID: peerID)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    // ファイルの送信はしないのでここは使わない
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        assertionFailure("非対応")
    }
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        assertionFailure("非対応")
    }
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        assertionFailure("非対応")
    }
}

extension CreatingRoomViewModel: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
//        invitationHandler(true, session)
    }
}


extension CreatingRoomViewModel: MCNearbyServiceBrowserDelegate {
    // 機器を検知した時
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("\(peerID.displayName)を発見しました")
        guard let session = session else {
            return
        }
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 0)
    }
    
    // 検知していた機器が消えた時
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("謎のばしょ")
    }
}
