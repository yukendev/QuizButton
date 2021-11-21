//
//  StandbyWireframe.swift
//  QuizButton
//
//  Created by 手塚友健 on 2021/11/10.
//

import Foundation

class CreatingRoomWireframe: Wireframe {
    func toQuizScreen(_ multiPeerConnectionService: MultiPeerConnectionService, roomNumber: Int) {
        let dependency = (
            multiPeerConnectionService,
            roomNumber
        )
        let quizVC = QuizViewController(with: dependency)
        viewController?.navigationController?.pushViewController(quizVC, animated: true)
    }
}
