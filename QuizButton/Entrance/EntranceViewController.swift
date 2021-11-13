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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = EntranceViewModel(sendButtonTap: sendButton.rx.tap.asSignal())
    }
    

}
