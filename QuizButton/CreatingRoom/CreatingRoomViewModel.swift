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
    
    
    let disposeBag = DisposeBag()
    
    private let memberUpdateRelay: BehaviorRelay<Void>
    let memberUpdated: Driver<Void>
    
    var dataSource: CreatingRoomDataSource!
    
    var standbyMember: [MCPeerID] = []
    
    
    var roomNumber: Int
    
    init(dependency: Dependency, roomNumber: Int) {
        
        self.roomNumber = roomNumber
        self.memberUpdateRelay = BehaviorRelay(value: ())
        self.memberUpdated = memberUpdateRelay.asDriver()
        
        self.dependency = dependency
        
        super.init()
        
        self.dependency.multiPeerConnectionService.delegate = self
        
        self.dataSource = CreatingRoomDataSource()
        
    }
    
    func addToStandbyMember(_ member: MCPeerID) {
        standbyMember.append(member)
        dataSource.setMember(standbyMember)
    }
    
    func addStandbyMember(_ member: MCPeerID) {
        if !standbyMember.contains(member) {
            standbyMember.append(member)
            dataSource.setMember(standbyMember)
            memberUpdateRelay.accept(())
        }
    }
    
    func deleteStandbyMember(_ member: MCPeerID) {
        standbyMember.removeAll(where: { $0 == member })
        dataSource.setMember(standbyMember)
        memberUpdateRelay.accept(())
    }
    
}

extension CreatingRoomViewModel: MultiPeerConnectionDelegate {
    func receiveHandler(sessionData: SessionData, fromPeer: MCPeerID) {
        guard let sessionType = SessionType(rawValue: sessionData.type) else {
            print("not implemented")
            return
        }
        switch sessionType {
        case .roomNumberRequest:
            guard let strRoomNumber = sessionData.data?["roomNumber"], let roomNumber = Int(strRoomNumber) else {
                return
            }
            print("部屋番号: \(roomNumber)でリクエストが来ました")
            if roomNumber == self.roomNumber {
                let sessionData = SessionData(type: SessionType.roomNumberApproval, data: nil)
                self.dependency.multiPeerConnectionService.sendData(sessionData)
            } else {
                let sessionData = SessionData(type: SessionType.roomNumberReject, data: nil)
                self.dependency.multiPeerConnectionService.sendData(sessionData)
            }
        default:
            print("not implemented")
            break
        }
    }
}
