//
//  EntranceWireframe.swift
//  QuizButton
//
//  Created by 手塚友健 on 2021/11/10.
//

import Foundation
import UIKit

class EntranceWireframe: Wireframe {
    
    func toStandby() {
        let storyboard = UIStoryboard(name: "Standby", bundle: nil)
        let standbyVC = storyboard.instantiateInitialViewController()
        guard let standbyVC = standbyVC else {
            return
        }
        viewController?.navigationController?.pushViewController(standbyVC, animated: true)
    }
}
