//
//  UserDefaultService.swift
//  QuizButton
//
//  Created by 手塚友健 on 2021/11/22.
//

import Foundation
import UIKit


final class UserDefaultService {
    static var shared: UserDefaultService = { return UserDefaultService() }()
    
    private init() {}
    
    private lazy var userDefaults = UserDefaults.standard
    
    private let roomNumberKey = "roomNumber"
    
    private(set) var roomNumber: Int {
        get {
            return userDefaults.integer(forKey: roomNumberKey)
        }
        set(value) {
            userDefaults.set(value, forKey: roomNumberKey)
        }
    }
    
    
    func setRoomNumber(_ roomNumber: Int) throws {
        if !(1000 <= roomNumber && roomNumber <= 9999) {
            throw QBError.roomNumberValidation
        }
        self.roomNumber = roomNumber
    }
    
    
}
