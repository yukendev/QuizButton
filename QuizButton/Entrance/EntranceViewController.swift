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
    
    deinit {
        print("deinit: \(type(of: self))")
    }
    
    
    @IBOutlet weak var roomNumberTextField: UITextField!
    @IBOutlet weak var sendButton: QBButton!
    
    private var viewModel: EntranceViewModel!
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = EntranceViewModel(
            dependency: (
                EntranceWireframe(self),
                AlertWireframe(self),
                MultiPeerConnectionService(multiPeerType: .guest)
            ),
            sendButtonTap: sendButton.rx.tap.asSignal()
        )
        
        roomNumberTextField.rx.text.orEmpty
            .bind(to: viewModel.roomNumberText)
            .disposed(by: disposeBag)
        
    }
    
    // 画面タップ時の処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

}
