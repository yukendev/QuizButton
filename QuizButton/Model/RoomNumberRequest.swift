//
//  RoomNumberRequest.swift.swift
//  QuizButton
//
//  Created by 手塚友健 on 2021/11/18.
//

import Foundation

enum RequestType: String {
    case request = "request"
    case approval = "approval"
    case reject = "reject"
}

struct RoomNumberRequest: Codable {
    let id: String
    let roomNumber: Int
    let requestType: RequestType.RawValue
    
    init(id: String, roomNumber: Int, requestType: RequestType) {
        self.id = id
        self.roomNumber = roomNumber
        self.requestType = requestType.rawValue
    }
}
