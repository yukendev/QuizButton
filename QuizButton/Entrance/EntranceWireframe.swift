//
//  EntranceWireframe.swift
//  QuizButton
//
//  Created by 手塚友健 on 2021/11/10.
//

import Foundation
import UIKit
import Instantiate
import InstantiateStandard

class EntranceWireframe: Wireframe {
    
    func toStandbyScreen(_ multiPeerConnectionService: MultiPeerConnectionService, roomNumber: Int) {
        let dependency = (
            multiPeerConnectionService,
            roomNumber
        )
        let standbyVC = StandbyViewController(with: dependency)
        viewController?.navigationController?.pushViewController(standbyVC, animated: true)
    }
}
