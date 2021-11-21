//
//  SessionType.swift
//  QuizButton
//
//  Created by 手塚友健 on 2021/11/19.
//

import Foundation


enum SessionType: String {
    
    case roomNumberRequest // 部屋番号のリクエスト
    case roomNumberApproval // 部屋番号リクエストの承認
    case roomNumberReject // 部屋番号リクエストの拒否
    
    case kickedFromRoom // 部屋に入った後にホストからキックされた場合
    
    case startQuiz // クイズの開始
    
    case roomDeleted // 部屋の解散
    
    case quizAnswer // 誰かが早押しボタンを押した
    
}
