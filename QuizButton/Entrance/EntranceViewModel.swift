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
    
    deinit {
        print("deinit: \(type(of: self))")
    }
    
    typealias Dependency = (
        wireframe: EntranceWireframe,
        alertWireframe: AlertWireframe,
        multiPeerConnectionService: MultiPeerConnectionService
    )
    private let dependency: Dependency
    
    let disposeBag = DisposeBag()
    
    // 承認データ受信フラグ
    private var isReceivedApproval: Bool = false
    
    // インジケーター
    let isInProgress: Driver<Bool>
    private let isInProgressRelay: BehaviorRelay = BehaviorRelay(value: false)

    var roomNumberText = BehaviorRelay<String>(value: "")
    
    let UD = UserDefaultService.shared
    
    init(dependency: Dependency, sendButtonTap: Signal<Void>) {
        
        self.dependency = dependency
        
        self.isInProgress = isInProgressRelay.asDriver()
        
        super.init()
        
        self.dependency.multiPeerConnectionService.delegate = self
        
        sendButtonTap.emit(onNext: { _ in
            if self.isAppropriateRoomNumber(self.roomNumberText.value) {
                // 部屋番号の送信
                guard let roomNumber = Int(self.roomNumberText.value) else {
                    self.dependency.alertWireframe.showSingleAlert(title: "エラーが発生しました", message: "") { _ in
                        self.dependency.wireframe.backToFirstScreen()
                    }
                    return
                }
                // 一定時間以内に部屋番号の承認が来なければアラート表示
                self.showAlertAfterSecond(second: 3)
                self.isInProgressRelay.accept(true)
                let sessionData = SessionData(type: SessionType.roomNumberRequest, roomNumber: roomNumber)
                self.dependency.multiPeerConnectionService.sendData(sessionData)
            } else {
                self.dependency.alertWireframe.showSingleAlert(title: "不適切な部屋番号です", message: "", completion: nil)
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
    
    // 一定時間後に部屋番号承認の通信が行われなければ、アラートを出す
    private func showAlertAfterSecond(second: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + second) {
            // 承認データ受信フラグがtrueなら何もしない
            self.isInProgressRelay.accept(false)
            if !self.isReceivedApproval {
                self.dependency.alertWireframe.showSingleAlert(title: "部屋が見つかりませんでした", message: "") { _ in
                    self.dependency.wireframe.backToFirstScreen()
                }
            }
        }
    }
}

// MARK: - MultiPeerConnectionDelegate
extension EntranceViewModel: MultiPeerConnectionDelegate {
    
    func didChangeState(peerID: MCPeerID, state: MCSessionState) {
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
    
    func didReceiveHandler(sessionData: SessionData, fromPeer: MCPeerID) {
        guard let sessionType = SessionType(rawValue: sessionData.type) else {
            print("not implemented")
            return
        }
        // 承認
        switch sessionType {
        case .roomNumberApproval:
            // 部屋番号が承認された時
            self.isInProgressRelay.accept(false)
            // 承認データ受信フラグをtrueにする
            self.isReceivedApproval = true
            // UDにroomNumberをセット
            do {
                try UD.setRoomNumber(sessionData.roomNumber)
            } catch let error {
                QBLogger.error(error)
            }
            DispatchQueue.main.async {
                self.dependency.wireframe.toStandbyScreen(self.dependency.multiPeerConnectionService)
            }
        default:
            break
        }
    }
}
