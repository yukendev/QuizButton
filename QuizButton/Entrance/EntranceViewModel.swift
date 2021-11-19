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
    
    typealias Dependency = (
        wireframe: EntranceWireframe,
        alrtWireframe: AlertWireframe,
        multiPeerConnectionService: MultiPeerConnectionService
    )
    private let dependency: Dependency
    
    let disposeBag = DisposeBag()

    var roomNumberText = BehaviorRelay<String>(value: "")
    
    init(dependency: Dependency, sendButtonTap: Signal<Void>) {
        
        self.dependency = dependency
        
        super.init()
        
        self.dependency.multiPeerConnectionService.delegate = self
        
        sendButtonTap.emit(onNext: { _ in
            if self.isAppropriateRoomNumber(self.roomNumberText.value) {
//                if !self.session.connectedPeers.isEmpty {
//                    // TODO: 部屋番号送信
//                    guard let roomNumber = Int(self.roomNumberText.value) else {
//                        return
//                    }
//                    self.sendRoomNumber(roomNumber)
//                } else {
//                    // 接続中の端末がない時
//                    self.dependency.alrtWireframe.showSingleAlert(title: "接続中の端末がないので部屋が見つかりません", message: "", completion: nil)
//                }
            } else {
                // TODO: VCでアラート表示
                self.dependency.alrtWireframe.showSingleAlert(title: "不適切な部屋番号です", message: "", completion: nil)
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
//    private func sendRoomNumber(_ roomNumber: Int) {
//        let request = RoomNumberRequest(id: self.peerID.displayName, roomNumber: roomNumber, requestType: RequestType.request)
//        let encoder = JSONEncoder()
//        do {
//            let jsonData = try encoder.encode(request)
//            try session.send(jsonData, toPeers: session.connectedPeers, with: .reliable)
//        } catch {
//            print("Entrance: 部屋番号が送信できません")
////            print(error.localizedDescription)
//        }
//    }
}

extension EntranceViewModel: MultiPeerConnectionDelegate {
    func receiveHandler(sessionData: SessionData, fromPeer: MCPeerID) {
        func receiveHandler(sessionData: SessionData, fromPeer: MCPeerID) {
            guard let sessionType = SessionType(rawValue: sessionData.type) else {
                print("not implemented")
                return
            }
            switch sessionType {
            case .roomNumberRequest:
                let decoder = JSONDecoder()
                do {
                    let data = try decoder.decode(RoomNumberRequestData.self, from: sessionData.data)
                    print("===============")
                    print(data.roomNumber)
                    print(type(of: data.roomNumber))
                    print("===============")
                } catch {
                    print(error.localizedDescription)
                }
            default:
                print("not implemented")
                break
            }
        }
    }
}
