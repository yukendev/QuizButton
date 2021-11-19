//
//  AlertWireframe.swift
//  QuizButton
//
//  Created by 手塚友健 on 2021/11/19.
//

import Foundation
import UIKit

class AlertWireframe: Wireframe {
    
    override init(_ viewController: UIViewController) {
        super.init(viewController)
        self.viewController = viewController
    }
    
    func showSingleAlert(title: String, message: String, completion: ((UIAlertAction) -> Void)?) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: completion)
        alert.addAction(okButton)
        guard let vc = viewController else {
            return
        }
        vc.present(alert, animated: true)
    }
    
}
