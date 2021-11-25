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
    
    deinit {
        print("deinit: \(type(of: self))")
    }
    
    func toStandbyScreen(_ multiPeerConnectionService: MultiPeerConnectionService) {
        let standbyVC = StandbyViewController(with: multiPeerConnectionService)
        viewController?.navigationController?.pushViewController(standbyVC, animated: true)
    }
}
