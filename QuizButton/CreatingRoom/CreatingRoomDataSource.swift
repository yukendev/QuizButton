//
//  CreatingRoomDataSource.swift
//  QuizButton
//
//  Created by 手塚友健 on 2021/11/19.
//

import Foundation
import UIKit
import MultipeerConnectivity


final class CreatingRoomDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var member: [MCPeerID] = []
    
    override init() {
        super.init()
    }
    
    func setMember(_ member: [MCPeerID]) {
        self.member = member
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return member.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreatingRoomTableViewCell", for: indexPath) as! CreatingRoomTableViewCell
        cell.setData(member[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    
}
