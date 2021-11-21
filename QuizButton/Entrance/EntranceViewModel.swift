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
                // 部屋番号の送信
                let data = ["roomNumber": self.roomNumberText.value]
                let sessionData = SessionData(type: SessionType.roomNumberRequest, data: data)
                self.dependency.multiPeerConnectionService.sendData(sessionData)
            } else {
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
}

extension EntranceViewModel: MultiPeerConnectionDelegate {
    func receiveHandler(sessionData: SessionData, fromPeer: MCPeerID) {
        guard let sessionType = SessionType(rawValue: sessionData.type) else {
            print("not implemented")
            return
        }
        switch sessionType {
        case .roomNumberApproval:
            print("部屋番号が承認されました")
        case .roomNumberReject:
            print("部屋番号が拒否されました")
        default:
            print("not implemented")
        }
    }
}
