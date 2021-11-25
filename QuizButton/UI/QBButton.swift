//
//  QBButton.swift
//  QuizButton
//
//  Created by 手塚友健 on 2021/11/26.
//

import Foundation
import UIKit

class QBButton: UIButton {
    
    private let shadowOffset: CGFloat = 3
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    private func configureUI() {
        self.layer.cornerRadius = 10
        addShadow(self.shadowOffset)
    }
    
    private func addShadow(_ shadowOffset: CGFloat) {
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 3
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: shadowOffset, height: shadowOffset)
    }
}

extension QBButton {
    // MARK: - Button Tap Method
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        pressedButtonAnimation()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        releasedButtonAnimation()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        releasedButtonAnimation()
    }
    
    // MARK: - Animation Method
    private func pressedButtonAnimation() {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn) {
            self.transform = CGAffineTransform(translationX: self.shadowOffset, y: self.shadowOffset)
        }
        self.addShadow(0)
    }
    
    private func releasedButtonAnimation() {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseOut) {
            self.transform = CGAffineTransform.identity
        }
        self.addShadow(self.shadowOffset)
    }
}
