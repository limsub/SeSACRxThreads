//
//  PhoneViewModel.swift
//  SeSACRxThreads
//
//  Created by 임승섭 on 2023/11/03.
//

import Foundation
import RxSwift
import RxCocoa

class PhoneViewModel {
    
    let phone = BehaviorSubject(value: "010")
    let buttonColor = BehaviorSubject(value: EnableColor.red.color)
    let buttonEnabled = BehaviorSubject(value: false)
    
    let disposeBag = DisposeBag()
    
    
    
    init() {
        
        // 4. 글자(phone) 수가 10글자 넘어가면 buttonColor를 바꿔주고 싶다 + buttonEnabled 값을 바꿔주고 싶다
        // (1). 기본
//        phone
//            .map { $0.count > 10 }  // Bool 타입으로 변환
//            .subscribe { value in
//                print("10글자가 넘었냐 : \(value)")
//                let color = value ? UIColor.blue : UIColor.red
//
//                self.buttonColor.onNext(color)  // 값 변경 (Subject의 값 변경 -> onNext)
////                self.buttonColor.on(.next(color)) // 이렇게도 쓸 수 있음 (위와 동일)
//            }
//            .disposed(by: disposeBag)
        
        // (2). 메모리 누수 신경쓰여. weak self 쓰고싶돠
//        phone
//            .map { $0.count > 10 }
//            .withUnretained(self)   // weak self의 역할을 한다.
//            //이걸 쓰는 순간, subscribe의 onNext 클로저 매개변수 타입이 바뀜
//            .subscribe { object, value in
//                let color = value ? UIColor.blue : UIColor.red
//                object.buttonColor.onNext(color)
//                object.buttonEnabled.onNext(value)
//            }
//            .disposed(by: disposeBag)
        
        // (3). unretained까지 이미 있는 거 사용할래
        phone
            .map { $0.count > 10 }
            .subscribe(with: self) { owner , value in
                let color = value ? EnableColor.blue.color : EnableColor.red.color
                owner.buttonColor.onNext(color)
                owner.buttonEnabled.onNext(value)
            }
            .disposed(by: disposeBag)
    }
}
