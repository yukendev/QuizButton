//
//  CreatingRoomDataSource.swift
//  QuizButton
//
//  Created by 手塚友健 on 2021/11/19.
//

import Foundation
import UIKit
import MultipeerConnectivity
import RxCocoa
import RxSwift


final class CreatingRoomDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    deinit {
        print("deinit: \(type(of: self))")
    }
    
    var member: [MCPeerID] = []
    
    let didSelectRow: PublishRelay = PublishRelay<MCPeerID>()
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < member.count {
            self.didSelectRow.accept(self.member[indexPath.row])
        }
    }
    
    
}
