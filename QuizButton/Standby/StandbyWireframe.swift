//
//  StandbyWireframe.swift
//  QuizButton
//
//  Created by 手塚友健 on 2021/11/21.
//

import Foundation


class StandbyWireframe: Wireframe {
    func toQuizScreen(_ multiPeerConnectionService: MultiPeerConnectionService) {
        let quizVC = QuizViewController(with: multiPeerConnectionService)
        viewController?.navigationController?.pushViewController(quizVC, animated: true)
    }
}
