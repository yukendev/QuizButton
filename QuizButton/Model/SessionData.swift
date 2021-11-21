//
//  SessionData.swift
//  QuizButton
//
//  Created by 手塚友健 on 2021/11/19.
//

import Foundation

struct SessionData: Codable {

    let type: SessionType.RawValue
    let data: [String: String]?

    init(type: SessionType, data: [String: String]?) {
        self.type = type.rawValue
        self.data = data
    }

}
