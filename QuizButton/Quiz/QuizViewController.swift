//
//  QuizViewController.swift
//  QuizButton
//
//  Created by 手塚友健 on 2021/11/21.
//

import UIKit
import Instantiate
import InstantiateStandard
import RxSwift


extension QuizViewController: StoryboardInstantiatable {
    // sessionを共有するために前の画面と同じMultiPeerConnectionServiceを使う
    typealias Dependency = MultiPeerConnectionService
    func inject(_ dependency: Dependency) {
        multiPeerConnectionService = dependency
    }
}

class QuizViewController: UIViewController {
    deinit {
        print("deinit: \(type(of: self))")
    }
    @IBOutlet weak var quizButton: UIButton!
    @IBOutlet weak var leaveButton: UIButton!
    
    
    private var viewModel: QuizViewModel!
    
    private var multiPeerConnectionService: MultiPeerConnectionService!
    
    private var roomNumber: Int!
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.viewModel = QuizViewModel(
            dependency: (
                QuizWireframe(self),
                AlertWireframe(self),
                self.multiPeerConnectionService
            ),
            input: (
                quizButton.rx.tap.asSignal(),
                leaveButton.rx.tap.asSignal()
            )
        )
        
        self.navigationItem.hidesBackButton = true
        
    }
    

}
