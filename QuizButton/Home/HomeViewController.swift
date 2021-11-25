//
//  HomeViewController.swift
//  QuizButton
//
//  Created by 手塚友健 on 2021/11/09.
//

import UIKit
import RxCocoa

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var createRoomButton: QBButton!
    @IBOutlet weak var enterRoomButton: QBButton!
    
    private var viewModel: HomeViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = HomeViewModel(
            input: (
                createRoomButton.rx.tap.asSignal(),
                enterRoomButton.rx.tap.asSignal()
            ), wireframe: HomeWireframe(self)
        )
    }
}
