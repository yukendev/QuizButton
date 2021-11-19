//
//  SessionData.swift
//  QuizButton
//
//  Created by 手塚友健 on 2021/11/19.
//

import Foundation
import MultipeerConnectivity


struct SessionData: Codable {

    let type: SessionType.RawValue
    let data: Data

    init(type: SessionType, data: Data) {
        self.type = type.rawValue
        self.data = data
    }

}

//struct SessionData<T: Codable>: Codable {
//
//    let type: SessionType.RawValue
//    let data: T
//
//    init(type: SessionType, data: T) {
//        self.type = type.rawValue
//        self.data = data
//    }
//
//}

class RoomNumberRequestData: Codable {
    var roomNumber: Int
}

class AnySessionData: RoomNumberRequestData {
    
}
