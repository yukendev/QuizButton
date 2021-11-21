//
//  StandbyViewModel.swift
//  QuizButton
//
//  Created by 手塚友健 on 2021/11/19.
//

import Foundation
import MultipeerConnectivity
import RxCocoa
import RxSwift

class StandbyViewModel: NSObject {
    
    typealias Dependency = (
        wireframe: StandbyWireframe,
        alertWireframe: AlertWireframe,
        multiPeerConnectionService: MultiPeerConnectionService
    )
    private let dependency: Dependency
    
    private let disposeBag = DisposeBag()
    
    private let roomNumber: Int
    
    
    deinit {
        print("deinit: \(type(of: self))")
    }
    
    init(dependency: Dependency, leaveButtonTap: Signal<Void>, roomNumber: Int) {
        
        self.dependency = dependency
        self.roomNumber = roomNumber
        
        super.init()
        
        self.dependency.multiPeerConnectionService.delegate = self
        
        leaveButtonTap.emit(onNext: { _ in
            self.dependency.wireframe.backToFirstScreen()
        }).disposed(by: disposeBag)
    }
}

// MARK: - MultiPeerConnectionDelegate
extension StandbyViewModel: MultiPeerConnectionDelegate {
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
        switch sessionType {
        case .kickedFromRoom:
            // 部屋から強制退出
            if sessionData.roomNumber == self.roomNumber {
                DispatchQueue.main.async {
                    self.dependency.alertWireframe.showSingleAlert(title: "部屋からキックされました", message: "") { _ in
                        self.dependency.wireframe.backToFirstScreen()
                    }
                }
            }
        case .startQuiz:
            // クイズが開始した時
            if sessionData.roomNumber == self.roomNumber {
                // 同じ部屋の人がクイズを開始した時
                DispatchQueue.main.async {
                    self.dependency.wireframe.toQuizScreen(self.dependency.multiPeerConnectionService, roomNumber: self.roomNumber)
                }
            }
        default:
            print("not implemented")
        }
    }
}
