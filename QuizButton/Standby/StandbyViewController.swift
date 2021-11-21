//
//  StandbyViewController.swift
//  QuizButton
//
//  Created by 手塚友健 on 2021/11/19.
//

import UIKit
import Instantiate
import InstantiateStandard


extension StandbyViewController: StoryboardInstantiatable {
    // sessionを共有するために前の画面と同じMultiPeerConnectionServiceを使う
    typealias Dependency = MultiPeerConnectionService
    func inject(_ dependency: Dependency) {
        multiPeerConnectionService = dependency
    }
}


class StandbyViewController: UIViewController {
    
    
    private var viewModel: StandbyViewModel!
    
    private var multiPeerConnectionService: MultiPeerConnectionService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = StandbyViewModel(
            dependency: (
                StandbyWireframe(self),
                AlertWireframe(self),
                multiPeerConnectionService
            ))
    }
}
