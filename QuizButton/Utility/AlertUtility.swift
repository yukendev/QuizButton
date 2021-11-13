//
//  AlertUtility.swift
//  QuizButton
//
//  Created by 手塚友健 on 2021/11/13.
//

import Foundation
import UIKit


final class AlertUtility {
    
    static func showSingleAlert(title: String, message: String, viewController: UIViewController?, completion: @escaping (UIAlertAction) -> Void) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: completion)
        alert.addAction(okButton)
        guard let vc = viewController else {
            return
        }
        vc.present(alert, animated: true)
    }
}
