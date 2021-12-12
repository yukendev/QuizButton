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
import GoogleMobileAds


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
    
    @IBOutlet weak var buttonOutsideView: UIView!
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    private var viewModel: QuizViewModel!
    
    private var multiPeerConnectionService: MultiPeerConnectionService!
    
    private var roomNumber: Int!
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerView.adUnitID = AdmobID.bannerID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        self.buttonOutsideView.layer.cornerRadius = 120
        self.quizButton.layer.cornerRadius = 90
                
        self.viewModel = QuizViewModel(
            dependency: (
                QuizWireframe(self),
                AlertWireframe(self),
                self.multiPeerConnectionService
            ),
            input: (
                quizButton.rx.controlEvent(.touchDown).asSignal(),
                leaveButton.rx.tap.asSignal()
            )
        )
        
        
        self.navigationItem.hidesBackButton = true
        
    }
    
    @IBAction func quizButtonAnimation(_ sender: Any) {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
            self.quizButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { (_) in
            UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options: .curveEaseOut, animations: {
                self.quizButton.transform = .identity
                
            }, completion: nil)
        }
    }
    

}
