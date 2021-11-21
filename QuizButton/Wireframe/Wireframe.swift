//
//  Wireframe.swift
//  QuizButton
//
//  Created by 手塚友健 on 2021/11/09.
//

import UIKit

class Wireframe {
    
    weak var viewController: UIViewController?
    
    init(_ viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func backToFirstScreen() {
        // 最初の画面に戻る
        self.viewController?.navigationController?.popToRootViewController(animated: true)
    }
}
