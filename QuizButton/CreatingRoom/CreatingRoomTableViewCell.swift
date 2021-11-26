//
//  CreatingRoomTableViewCell.swift
//  QuizButton
//
//  Created by 手塚友健 on 2021/11/19.
//

import UIKit
import MultipeerConnectivity

class CreatingRoomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    var member: MCPeerID?

    private func updateObject() {
        guard let member = member else {
            return
        }
        self.nameLabel.text = member.displayName
    }
    
    func setData(_ member: MCPeerID) {
        self.member = member
        updateObject()
    }
    
}
