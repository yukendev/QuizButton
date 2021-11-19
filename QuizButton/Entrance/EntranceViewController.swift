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
        
        viewModel = EntranceViewModel(
            dependency: (
                EntranceWireframe(self),
                AlertWireframe(self)
            ),
            sendButtonTap: sendButton.rx.tap.asSignal()
        )
        
        roomNumberTextField.rx.text.orEmpty
            .bind(to: viewModel.roomNumberText)
            .disposed(by: disposeBag)
        
    }
    

}
