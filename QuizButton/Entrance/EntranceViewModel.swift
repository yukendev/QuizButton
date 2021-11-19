//
//  EntranceViewModel.swift
//  QuizButton
//
//  Created by 手塚友健 on 2021/11/10.
//

import Foundation
import RxCocoa
import RxSwift
import MultipeerConnectivity

class EntranceViewModel: NSObject {
    
    let disposeBag = DisposeBag()
    
    private let serviceType = "QuizButton"
    private var session: MCSession!
    private var advertiser: MCNearbyServiceAdvertiser!
    private var browser: MCNearbyServiceBrowser!
    private let peerID = MCPeerID(displayName: UIDevice.current.name)
    
    private let roomNumberValidationRelay = PublishRelay<Bool>()
    let isAppropriateRoomNumber: Signal<Bool>
    var roomNumberText = BehaviorRelay<String>(value: "")
    
    init(sendButtonTap: Signal<Void>) {
        
        self.isAppropriateRoomNumber = roomNumberValidationRelay.asSignal()
        
        super.init()
        
        session = MCSession(peer: peerID)
        session.delegate = self
        
        advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceType)
        advertiser.delegate = self
        advertiser.startAdvertisingPeer()
        
        browser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)
        browser.delegate = self
        browser.startBrowsingForPeers()
        
        sendButtonTap.emit(onNext: { _ in
            if self.isAppropriateRoomNumber(self.roomNumberText.value) {
                // Wireframeで画面遷移
                self.roomNumberValidationRelay.accept(true)
                guard let roomNumber = Int(self.roomNumberText.value) else {
                    return
                }
                self.sendRoomNumber(roomNumber)
            } else {
                // VCでアラートを表示
                self.roomNumberValidationRelay.accept(false)
            }
        }).disposed(by: disposeBag)
    }
    
    // 部屋番号のバリデーション
    private func isAppropriateRoomNumber(_ roomNumberText: String) -> Bool {
        guard let roomNumber: Int = Int(roomNumberText) else {
            return false
        }
        return 1000 <= roomNumber && roomNumber <= 9999
    }
    
    // 部屋番号の送信
    private func sendRoomNumber(_ roomNumber: Int) {
        let request = RoomNumberRequest(id: self.peerID.displayName, roomNumber: roomNumber, requestType: RequestType.request)
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(request)
            try session.send(jsonData, toPeers: session.connectedPeers, with: .reliable)
        } catch {
            print(error.localizedDescription)
        }
    }
}


extension EntranceViewModel: MCSessionDelegate {
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
            let response = try decoder.decode(RoomNumberRequest.self, from: data)
            print("from: \(response.id)\nroomNumber: \(response.roomNumber)\nrequestType: \(response.requestType)")
            switch RequestType(rawValue: response.requestType) {
            case .approval:
                print("approval")
            case .reject:
                print("reject")
            default:
                print("default")
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

extension EntranceViewModel: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, session)
    }
}


extension EntranceViewModel: MCNearbyServiceBrowserDelegate {
    // 機器を検知した時
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("\(peerID.displayName)を発見しました")
//        guard let session = session else {
//            return
//        }
//        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 0)
    }
    
    // 検知していた機器が消えた時
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("謎のばしょ")
    }
}
