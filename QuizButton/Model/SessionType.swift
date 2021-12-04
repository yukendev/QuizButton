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
    
    case kickedFromRoom // 部屋に入った後にホストからキックされた場合
    
    case startQuiz // クイズの開始
    
    case roomDeleted // 部屋の解散
    
    case quizStartAnswer // 誰かが早押しボタンを押した(解答を開始)
    case quizFinishAnswer // 誰かが解答を終了
    
}
