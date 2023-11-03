//
//  NicknameViewModel.swift
//  SeSACRxThreads
//
//  Created by 임승섭 on 2023/11/03.
//

import Foundation
import RxSwift
import RxCocoa

class NicknameViewModel {
    
    let nicknameStr = BehaviorSubject(value: "")
    let buttonHidden = BehaviorSubject(value: false)
    
    let disposeBag = DisposeBag()
    
    
    init() {
        
        // 1 - 2. nicknameStr (count) -> buttonHidden
        nicknameStr
            .map { $0.count >= 2 && $0.count < 6 }
            .subscribe(with: self) { owner , value in
                owner.buttonHidden.onNext(!value)
            }
            .disposed(by: disposeBag)
    }
    
}
