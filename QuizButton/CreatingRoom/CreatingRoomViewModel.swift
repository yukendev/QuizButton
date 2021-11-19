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
    
//    func sendResponse(response: RoomNumberRequest, peerID: MCPeerID) {
//        let encoder = JSONEncoder()
//        do {
//            let jsonData = try encoder.encode(response)
//            try session.send(jsonData, toPeers: [peerID], with: .reliable)
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
    
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
            let decoder = JSONDecoder()
            do {
                let data = try decoder.decode(RoomNumberRequestData.self, from: sessionData.data)
                print("================")
                print(data.roomNumber)
                print(type(of: data.roomNumber))
                print("================")
            } catch {
                print(error.localizedDescription)
            }
        default:
            print("not implemented")
            break
        }
    }
}
