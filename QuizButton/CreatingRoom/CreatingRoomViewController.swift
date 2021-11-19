//
//  StandbyViewController.swift
//  QuizButton
//
//  Created by 手塚友健 on 2021/11/09.
//

import UIKit

class CreatingRoomViewController: UIViewController {
    
    @IBOutlet weak var roomNumberLabel: UILabel!
    
    let roomNumber = Int.random(in: 1000..<9999)
    
    private var viewModel: CreatingRoomViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 部屋番号をラベルに表示
        roomNumberLabel.text = String(roomNumber)
        
        viewModel = CreatingRoomViewModel(roomNumber: roomNumber)

    }
    
}


