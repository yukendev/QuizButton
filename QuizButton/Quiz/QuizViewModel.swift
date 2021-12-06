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
import AVFoundation


class QuizViewModel: NSObject {
    
    deinit {
        print("deinit: \(type(of: self))")
    }
    
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
    
    private var player: AVAudioPlayer?
    
    private var canSendData: Bool = true
        
    private let isHiddenAnsweringViewRelay: BehaviorRelay<Bool> = BehaviorRelay(value: true)
    let isHiddenAnsweringViewDriver: Driver<Bool>
    
    let UD = UserDefaultService.shared
    
    let answeringView = AnsweringView()
    
    init(dependency: Dependency, input: Input) {
        
        self.dependency = dependency
        self.isHiddenAnsweringViewDriver = self.isHiddenAnsweringViewRelay.asDriver()
        
        super.init()
        
        self.dependency.multiPeerConnectionService.delegate = self
        self.answeringView.delegate = self
        
        // 解答ボタン
        input.quizButtonTap.emit(onNext: { _ in
            if self.canSendData {
                self.quizSound()
                let sessionData = SessionData(type: .quizStartAnswer, roomNumber: self.UD.roomNumber)
                self.dependency.multiPeerConnectionService.sendData(sessionData, toPeer: nil)
                self.dependency.wireframe.showAnsweringScreen(answeringType: .answer, answeringView: self.answeringView)
            }
        }).disposed(by: disposeBag)
        
        // 退出ボタン
        input.leaveButtonTap.emit(onNext: { _ in
            self.dependency.alertWireframe.showDoubleAlert(title: "部屋を退出します。よろしいですか？", message: "") { _ in
                self.dependency.wireframe.backToFirstScreen()
            }
        }).disposed(by: disposeBag)
    }
    
    private func quizSound() {
        if let soundURL = Bundle.main.url(forResource: "Quiz-Buzzer02-1", withExtension: "mp3") {
            do {
                player = try AVAudioPlayer(contentsOf: soundURL)
                player?.play()
            } catch {
                print("error")
            }
        }
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
        guard sessionData.roomNumber == self.UD.roomNumber else {
            return
        }
        guard let sessionType = SessionType(rawValue: sessionData.type) else {
            print("not implemented")
            return
        }
        switch sessionType {
        case .roomDeleted:
            // 部屋が強制解散された時
            DispatchQueue.main.async {
                self.dependency.alertWireframe.showSingleAlert(title: "部屋が解散されました", message: "") { _ in
                    self.dependency.wireframe.backToFirstScreen()
                }
            }
        case .quizStartAnswer:
            // 誰かがボタンを押した時
            self.canSendData = false
            DispatchQueue.main.async {
                self.dependency.wireframe.showAnsweringScreen(answeringType: .others, answeringView: self.answeringView)
            }
        case .quizFinishAnswer:
            // 誰かが解答を終了した時
            self.canSendData = true
            DispatchQueue.main.async {
                self.answeringView.removeFromSuperview()
            }
        default:
            break
        }
    }
}

// MARK: - AnsweringDelegate
extension QuizViewModel: AnsweringViewDelegate {
    func answeringButtonTapped(_ answeringType: AnsweringType) {
        switch answeringType {
        case .answer:
            // 自分の解答終了
            let sessionData = SessionData(type: .quizFinishAnswer, roomNumber: self.UD.roomNumber)
            self.dependency.multiPeerConnectionService.sendData(sessionData, toPeer: nil)
            self.answeringView.removeFromSuperview()
        case .others:
            // 部屋を退出
            self.dependency.alertWireframe.showDoubleAlert(title: "部屋を退出します。よろしいですか？", message: "") { _ in
                self.dependency.wireframe.backToFirstScreen()
            }
        }
    }
}
