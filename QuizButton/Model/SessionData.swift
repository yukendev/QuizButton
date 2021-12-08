//
//  SessionData.swift
//  QuizButton
//
//  Created by 手塚友健 on 2021/11/19.
//

import Foundation

struct SessionData: Codable {

    let type: SessionType.RawValue
    let roomNumber: Int
    let answerPower: Int

    init(type: SessionType, roomNumber: Int, answerPower: Int = 0) {
        self.type = type.rawValue
        self.roomNumber = roomNumber
        self.answerPower = answerPower
    }
}

