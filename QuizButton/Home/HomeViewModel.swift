//
//  HomeViewModel.swift
//  QuizButton
//
//  Created by 手塚友健 on 2021/11/09.
//

import Foundation
import RxCocoa
import RxSwift


class HomeViewModel {
    
    typealias Input = (
        createRoomButtonTap: Signal<Void>,
        searchRoomButtonTap: Signal<Void>
    )
    
    let disposeBag = DisposeBag()
    
    init(input: Input, wireframe: HomeWireframe) {
        
        input.createRoomButtonTap.emit(onNext: {
            print("部屋を作る")
            wireframe.toStandbyVC()
        }).disposed(by: disposeBag)
        input.searchRoomButtonTap.emit(onNext: {
            print("部屋を探す")
            wireframe.toEntranceVC()
        }).disposed(by: disposeBag)
        
    }
    
}
