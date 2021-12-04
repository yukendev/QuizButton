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
    
    // インジケーター
    var indicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // インジケーターの設定
        indicator.center = CGPoint(x: self.view.center.x, y: self.view.center.y - 40)
        self.view.addSubview(indicator)
        
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
        
        viewModel.isInProgress.distinctUntilChanged().drive(onNext: { [weak self] isInProgress in
            if isInProgress {
                // インジケーター回転開始
                self?.indicator.startAnimating()
                self?.view.endEditing(true)
            } else {
                // インジケーター回転終了
                self?.indicator.stopAnimating()
            }
        }).disposed(by: disposeBag)
        
    }
    
    // 画面タップ時の処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

}
