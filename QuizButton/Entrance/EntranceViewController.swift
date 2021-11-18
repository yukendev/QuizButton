//
//  EntranceViewController.swift
//  QuizButton
//
//  Created by 手塚友健 on 2021/11/09.
//

import UIKit
import RxSwift
import RxCocoa

class EntranceViewController: UIViewController {
    
    
    @IBOutlet weak var roomNumberTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    private var viewModel: EntranceViewModel!
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = EntranceViewModel(sendButtonTap: sendButton.rx.tap.asSignal())
        
        roomNumberTextField.rx.text.orEmpty
            .bind(to: viewModel.roomNumberText)
            .disposed(by: disposeBag)
        
        viewModel.isAppropriateRoomNumber.emit(onNext: { isAppropriateRoomNumber in
            if isAppropriateRoomNumber {
                print("適切な部屋番号です")
            } else {
                // TODO: バリデーションのアラート表示
                AlertUtility.showSingleAlert(title: "不適切な部屋番号です", message: "", viewController: self) { _ in
                    self.roomNumberTextField.text = ""
                }
            }
        }).disposed(by: disposeBag)
        
    }
    

}
