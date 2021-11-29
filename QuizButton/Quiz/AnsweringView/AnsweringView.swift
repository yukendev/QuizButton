//
//  AnsweringView.swift
//  QuizButton
//
//  Created by 手塚友健 on 2021/11/22.
//

import UIKit

// MARK: - AnsweringDelegate
protocol AnsweringViewDelegate: AnyObject {
    func answeringButtonTapped(_ answeringType: AnsweringType)
}

// MARK: - AnsweringType
enum AnsweringType {
    case answer
    case others
}



class AnsweringView: UIView {
    
    @IBOutlet weak var answeringLabel: UILabel!
    
    @IBOutlet weak var finishAnswerButton: QBButton!
    @IBOutlet weak var leaveRoomButton: UIButton!
    
    private var answeringType: AnsweringType!
    
    weak var delegate: AnsweringViewDelegate!
    
    
    // MARK: - DI
    func inject(_ answeringType: AnsweringType) {
        self.answeringType = answeringType
        self.updateObject(answeringType)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNib()
    }
    
    private func loadNib() {
        let view = UINib(nibName: "AnsweringView", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    private func updateObject(_ answeringType: AnsweringType) {
        switch answeringType {
        case .answer:
            self.answeringLabel.text = "あなたが回答者です"
            self.finishAnswerButton.isHidden = false
            self.leaveRoomButton.isHidden = true
        case .others:
            self.answeringLabel.text = "他の人が回答しています"
            self.finishAnswerButton.isHidden = true
            self.leaveRoomButton.isHidden = false
        }
    }
    
    // MARK: - ButtonTapAction
    @IBAction func answeringButtonTap(_ sender: Any) {
        self.delegate.answeringButtonTapped(self.answeringType)
    }
    
    
}
