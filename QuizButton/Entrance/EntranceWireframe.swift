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
    
    func toStandby(dependency multiPeerConnectionService: MultiPeerConnectionService) {
        let standbyVC = StandbyViewController(with: multiPeerConnectionService)
        viewController?.navigationController?.pushViewController(standbyVC, animated: true)
    }
}
