//
//  QBError.swift
//  QuizButton
//
//  Created by 手塚友健 on 2021/11/22.
//

import Foundation


enum QBError: LocalizedError {
    
    case roomNumberValidation // 部屋番号のバリデーションエラー
    
    var errorDescription: String? {
        switch self {
        case .roomNumberValidation: return "The room number is invalid."
        }
    }
}
