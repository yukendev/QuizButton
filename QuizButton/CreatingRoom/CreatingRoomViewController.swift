//
//  StandbyViewController.swift
//  QuizButton
//
//  Created by 手塚友健 on 2021/11/09.
//

import UIKit
import RxSwift
import RxCocoa

class CreatingRoomViewController: UIViewController {
    
    deinit {
        print("deinit: \(type(of: self))")
    }
    
    @IBOutlet weak var roomNumberLabel: UILabel!
    @IBOutlet weak var quizStartButton: UIButton!
    @IBOutlet weak var standbyMemberLabel: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "CreatingRoomTableViewCell", bundle: nil), forCellReuseIdentifier: "CreatingRoomTableViewCell")
            tableView.separatorStyle = .none
        }
    }
    
    let roomNumber = Int.random(in: 1000..<9999)
    
    let disposeBag = DisposeBag()
    
    private var viewModel: CreatingRoomViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 部屋番号をラベルに表示
        roomNumberLabel.text = String(roomNumber)
        
        viewModel = CreatingRoomViewModel(dependency: (
            CreatingRoomWireframe(self),
            AlertWireframe(self),
            MultiPeerConnectionService()
        ), roomNumber: roomNumber)
        
        viewModel.memberUpdated.drive(onNext: { [weak self] _ in
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        self.tableView.delegate = viewModel.dataSource
        self.tableView.dataSource = viewModel.dataSource
    }
    
}

