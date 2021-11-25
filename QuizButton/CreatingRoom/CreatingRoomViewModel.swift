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
    
    deinit {
        print("deinit: \(type(of: self))")
    }
    
    typealias Dependency = (
        wireframe: CreatingRoomWireframe,
        alertWireframe: AlertWireframe,
        multiPeerConnectionService: MultiPeerConnectionService
    )
    private let dependency: Dependency
    
    typealias Input = (
        startButtonTap: Signal<Void>,
        dissolveButtonTap: Signal<Void>
    )
    
    
    let disposeBag = DisposeBag()
    
    private let memberUpdateRelay: BehaviorRelay<Void>
    let memberUpdated: Driver<Void>
    
    var dataSource: CreatingRoomDataSource!
    
    var standbyMember: [MCPeerID] = []
    
    var numberOfStandbyMember: Driver<Int>
    private let numberOfStandbyMemberRelay: BehaviorRelay<Int>
    
    let UD = UserDefaultService.shared
    
    init(dependency: Dependency, input: Input) {
        
        self.memberUpdateRelay = BehaviorRelay(value: ())
        self.memberUpdated = memberUpdateRelay.asDriver()
        
        self.numberOfStandbyMemberRelay = BehaviorRelay(value: 0)
        self.numberOfStandbyMember = numberOfStandbyMemberRelay.asDriver()
        
        self.dependency = dependency
        
        super.init()
        
        self.dependency.multiPeerConnectionService.delegate = self
        
        self.dataSource = CreatingRoomDataSource()
        
        // セルタップ時の処理
        self.dataSource.didSelectRow.subscribe(onNext: { [weak self] peerID in
            guard let `self` = self else { return }
            self.dependency.alertWireframe.showDoubleAlert(
                title: "\(peerID.displayName)さんを退出させますか?",
                message: "",
                completion: { _ in
                    self.deleteStandbyMember(peerID)
                    let sessionData = SessionData(type: .kickedFromRoom, roomNumber: self.UD.roomNumber)
                    self.dependency.multiPeerConnectionService.sendData(sessionData, toPeer: [peerID])
                })
        }).disposed(by: disposeBag)
        
        
        input.dissolveButtonTap.emit(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            self.dependency.alertWireframe.showDoubleAlert(title: "部屋を解散します。よろしいですか？", message: "") { _ in
                let sessionData = SessionData(type: .kickedFromRoom, roomNumber: self.UD.roomNumber)
                self.dependency.multiPeerConnectionService.sendData(sessionData, toPeer: nil)
                self.dependency.wireframe.backToFirstScreen()
            }
        }).disposed(by: disposeBag)
        
        input.startButtonTap.emit(onNext: { _ in
            
            if self.standbyMember.isEmpty {
                return self.dependency.alertWireframe.showSingleAlert(title: "メンバーがいません", message: "", completion: nil)
            }
            
            self.dependency.alertWireframe.showDoubleAlert(title: "クイズを開始します。よろしいですか？", message: "") { _ in
                let sessionData = SessionData(type: .startQuiz, roomNumber: self.UD.roomNumber)
                self.dependency.multiPeerConnectionService.sendData(sessionData)
                self.dependency.wireframe.toQuizScreen(self.dependency.multiPeerConnectionService)
            }
            
            
        }).disposed(by: disposeBag)
        
    }
    
    func addStandbyMember(_ member: MCPeerID) {
        if !standbyMember.contains(member) {
            standbyMember.append(member)
            dataSource.setMember(standbyMember)
            numberOfStandbyMemberRelay.accept(standbyMember.count)
            memberUpdateRelay.accept(())
        }
    }
    
    func deleteStandbyMember(_ member: MCPeerID) {
        standbyMember.removeAll(where: { $0 == member })
        dataSource.setMember(standbyMember)
        numberOfStandbyMemberRelay.accept(standbyMember.count)
        memberUpdateRelay.accept(())
    }
    
}

// MARK: - MultiPeerConnectionDelegate
extension CreatingRoomViewModel: MultiPeerConnectionDelegate {
    
    func didChangeState(peerID: MCPeerID, state: MCSessionState) {
        switch state {
        case .notConnected:
            print("\(peerID.displayName)が切断されました")
            self.deleteStandbyMember(peerID)
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
        case .roomNumberRequest:
            if sessionData.roomNumber == self.UD.roomNumber {
                // 部屋番号承認
                let sessionData = SessionData(type: SessionType.roomNumberApproval, roomNumber: self.UD.roomNumber)
                self.dependency.multiPeerConnectionService.sendData(sessionData, toPeer: [fromPeer])
                // TODO: 待機中のメンバーに追加
                self.addStandbyMember(fromPeer)
            } else {
                // 部屋番号拒否
                let sessionData = SessionData(type: SessionType.roomNumberReject, roomNumber: self.UD.roomNumber)
                self.dependency.multiPeerConnectionService.sendData(sessionData, toPeer: [fromPeer])
            }
        default:
            break
        }
    }
}
