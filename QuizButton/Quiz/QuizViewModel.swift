//
//  QuizViewModel.swift
//  QuizButton
//
//  Created by 手塚友健 on 2021/11/21.
//

import Foundation
import RxSwift
import RxCocoa
import MultipeerConnectivity


class QuizViewModel: NSObject {
    
    typealias Dependency = (
        wireframe: QuizWireframe,
        alertWireframe: AlertWireframe,
        multiPeerConnectionService: MultiPeerConnectionService
    )
    
    typealias Input = (
        quizButtonTap: Signal<Void>,
        leaveButtonTap: Signal<Void>
    )
    
    private let dependency: Dependency
    
    private let disposeBag = DisposeBag()
    
    private let roomNumber: Int
    
    init(dependency: Dependency, input: Input, roomNumber: Int) {
        
        self.dependency = dependency
        self.roomNumber = roomNumber
        
        super.init()
        
        self.dependency.multiPeerConnectionService.delegate = self
        
        // 解答ボタン
        input.quizButtonTap.emit(onNext: { _ in
            // TODO: QuizButtonタップ処理
            let sessionData = SessionData(type: .quizAnswer, roomNumber: roomNumber)
            self.dependency.multiPeerConnectionService.sendData(sessionData, toPeer: nil)
        }).disposed(by: disposeBag)
        
        // 退出ボタン
        input.leaveButtonTap.emit(onNext: { _ in
            switch self.dependency.multiPeerConnectionService.multiPeerType {
            case .host:
                self.dependency.alertWireframe.showDoubleAlert(title: "部屋を解散します。よろしいですか？", message: "") { _ in
                    let sessionData = SessionData(type: .roomDeleted, roomNumber: roomNumber)
                    self.dependency.multiPeerConnectionService.sendData(sessionData, toPeer: nil)
                    self.dependency.wireframe.backToFirstScreen()
                }
            case .guest:
                self.dependency.alertWireframe.showDoubleAlert(title: "部屋を退出します。よろしいですか？", message: "") { _ in
                    self.dependency.wireframe.backToFirstScreen()
                }
            }
            self.dependency.wireframe.backToFirstScreen()
        }).disposed(by: disposeBag)
    }
}

// MARK: - MultiPeerConnectionDelegate
extension QuizViewModel: MultiPeerConnectionDelegate {
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
        case .roomDeleted:
            // TODO: 部屋の解散処理
            if sessionData.roomNumber == self.roomNumber {
                print("部屋の解散")
            }
        case .quizAnswer:
            // TODO: 誰かが早押しボタンを押した時の処理
            if sessionData.roomNumber == self.roomNumber {
                print("クイズの解答")
            }
        default:
            print("not implemented")
        }
    }
}
