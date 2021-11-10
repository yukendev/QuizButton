//
//  EntranceViewModel.swift
//  QuizButton
//
//  Created by 手塚友健 on 2021/11/10.
//

import Foundation
import RxCocoa
import RxSwift

class EntranceViewModel {
    
    let disposeBag = DisposeBag()
    
    init(sendButtonTap: Signal<Void>) {
        
        sendButtonTap.emit(onNext: {
            print("送信ボタンがタップされました")
        }).disposed(by: disposeBag)
    }
}
