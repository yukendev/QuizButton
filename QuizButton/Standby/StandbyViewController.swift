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
    typealias Dependency = (
        multiPeerConnectionService: MultiPeerConnectionService,
        roomNumber: Int
    )
    func inject(_ dependency: Dependency) {
        multiPeerConnectionService = dependency.multiPeerConnectionService
        roomNumber = dependency.roomNumber
    }
}


class StandbyViewController: UIViewController {
    
    deinit {
        print("deinit: \(type(of: self))")
    }
    
    @IBOutlet weak var leaveButton: UIButton!
    
    private var viewModel: StandbyViewModel!
    
    private var multiPeerConnectionService: MultiPeerConnectionService!
    
    private var roomNumber: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = StandbyViewModel(
            dependency: (
                StandbyWireframe(self),
                AlertWireframe(self),
                multiPeerConnectionService
            ),
            leaveButtonTap: leaveButton.rx.tap.asSignal(),
            roomNumber: roomNumber
        )
    }
}
