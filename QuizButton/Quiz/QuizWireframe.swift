//
//  QuizWireframe.swift
//  QuizButton
//
//  Created by 手塚友健 on 2021/11/21.
//

import Foundation
import UIKit

class QuizWireframe: Wireframe {
        
    func showAnsweringScreen(answeringType: AnsweringType, answeringView: AnsweringView) {
        answeringView.frame = CGRect(x: 0, y: 0, width: (self.viewController?.view.frame.width)!, height: (self.viewController?.view.frame.height)!)
        answeringView.inject(answeringType)
        self.viewController?.view.addSubview(answeringView)
    }
}
