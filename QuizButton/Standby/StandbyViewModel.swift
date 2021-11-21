//
//  StandbyViewModel.swift
//  QuizButton
//
//  Created by 手塚友健 on 2021/11/19.
//

import Foundation
import MultipeerConnectivity

class StandbyViewModel: NSObject {
    
    typealias Dependency = (
        wireframe: StandbyWireframe,
        alertWireframe: AlertWireframe,
        multiPeerConnectionService: MultiPeerConnectionService
    )
    private let dependency: Dependency
    
    
    deinit {
        print("deinit: \(type(of: self))")
    }
    
    init(dependency: Dependency) {
        
        self.dependency = dependency
        
        super.init()
        
        self.dependency.multiPeerConnectionService.delegate = self
    }
}

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
            DispatchQueue.main.async {
                self.dependency.alertWireframe.showSingleAlert(title: "部屋からキックされました", message: "") { _ in
                    self.dependency.wireframe.bachToFirstScreen()
                }
            }
        default:
            print("not implemented")
        }
    }
}
