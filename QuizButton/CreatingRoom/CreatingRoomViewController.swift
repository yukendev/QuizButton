//
//  StandbyViewController.swift
//  QuizButton
//
//  Created by 手塚友健 on 2021/11/09.
//

import UIKit
import RxSwift
import RxCocoa
import GoogleMobileAds

class CreatingRoomViewController: UIViewController {
    
    deinit {
        print("deinit: \(type(of: self))")
    }
    
    @IBOutlet weak var dissolveButton: UIButton!
    @IBOutlet weak var roomNumberLabel: UILabel!
    @IBOutlet weak var quizStartButton: QBButton!
    @IBOutlet weak var standbyMemberLabel: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "CreatingRoomTableViewCell", bundle: nil), forCellReuseIdentifier: "CreatingRoomTableViewCell")
            tableView.separatorStyle = .none
        }
    }
    
    @IBOutlet weak var bannerView: GADBannerView!
    
        
    let disposeBag = DisposeBag()
    
    private var viewModel: CreatingRoomViewModel!
    
    let UD = UserDefaultService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Admob設定
        bannerView.adUnitID = AdmobID.bannerID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        // UserDefaultsに部屋番号を保存
        do {
            try UD.setRoomNumber(Int.random(in: 1000..<9999))
        } catch let error {
            QBLogger.error(error)
        }
        
        // 部屋番号をラベルに表示
        roomNumberLabel.text = String(UD.roomNumber)
        
        viewModel = CreatingRoomViewModel(
            dependency: (
                CreatingRoomWireframe(self),
                AlertWireframe(self),
                MultiPeerConnectionService(multiPeerType: .host)
            ), input: (
                quizStartButton.rx.tap.asSignal(),
                dissolveButton.rx.tap.asSignal()
            )
        )
        
        viewModel.memberUpdated.drive(onNext: { [weak self] _ in
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.numberOfStandbyMember.drive(onNext: { [weak self] numberOfStandbyMember in
            self?.standbyMemberLabel.text = "\(numberOfStandbyMember)人が待機中..."
        }).disposed(by: disposeBag)
        
        
        self.tableView.delegate = viewModel.dataSource
        self.tableView.dataSource = viewModel.dataSource
        
        self.navigationItem.hidesBackButton = true
    }
    
}


