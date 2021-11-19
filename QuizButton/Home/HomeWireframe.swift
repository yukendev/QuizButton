//
//  HomeWireframe.swift
//  QuizButton
//
//  Created by 手塚友健 on 2021/11/09.
//

import Foundation
import UIKit

final class HomeWireframe: Wireframe {
    
    func toStandbyVC() {
        let storyboard = UIStoryboard(name: "CreatingRoom", bundle: nil)
        let creatingRoomVC = storyboard.instantiateInitialViewController()
        guard let creatingRoomVC = creatingRoomVC else {
            return
        }
        viewController?.navigationController?.pushViewController(creatingRoomVC, animated: true)
    }
    
    func toEntranceVC() {
        let storyboard = UIStoryboard(name: "Entrance", bundle: nil)
        let entranceVC = storyboard.instantiateInitialViewController()
        guard let entranceVC = entranceVC else {
            return
        }
        viewController?.navigationController?.pushViewController(entranceVC, animated: true)
    }
    
}
