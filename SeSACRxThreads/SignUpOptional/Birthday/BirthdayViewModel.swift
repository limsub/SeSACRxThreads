//
//  BirthdayViewModel.swift
//  SeSACRxThreads
//
//  Created by 임승섭 on 2023/11/03.
//

import UIKit
import RxSwift
import RxCocoa


class BirthdayViewModel {
    
    let birthDay: BehaviorSubject<Date> = BehaviorSubject(value: .now)
    
    let year = BehaviorSubject(value: 2020)
    let month = BehaviorSubject(value: 12)
    let day = BehaviorSubject(value: 22)
    
    let buttonColor = BehaviorSubject(value: UIColor.red)
    let buttonEnabled = BehaviorSubject(value: false)
    
    let disposeBag = DisposeBag()
    
    init() {
        
        // 2 - 1. birthDay의 값 가공 -> year, month, day
        birthDay
            .subscribe(with: self) { owner , date  in
                let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
                
                owner.year.onNext(component.year!)
                owner.month.onNext(component.month!)
                owner.day.onNext(component.day!)
                
            }
            .disposed(by: disposeBag)
        
        // 2 - 2. birthDay와 오늘 날짜 비교 -> buttonColor, buttonEnabled
        // (1). (day의 차를 이용해서 계산 -> 며칠 차이가 생긴다. 윤년 때문인가?)
//        birthDay
//            .map { Calendar.current.dateComponents([.day], from: $0, to: Date()).day! >= 365 * 17}
//            .subscribe(with: self) { owner , value in
//
//                let color = value ? UIColor.blue : UIColor.red
//                owner.buttonColor.onNext(color)
//                owner.buttonEnabled.onNext(value)
//            }
//            .disposed(by: disposeBag)
        // (2). 오늘 날짜의 연, 월, 날 뽑아서 연만 17 뺀 걸로 계산
        birthDay
            .map { date in
                let tenYearsAgo = Calendar.current.date(byAdding: .year, value: -17, to: Date())!
                return date < tenYearsAgo
            }
            .subscribe(with: self) { owner , value in
                let color = value ? UIColor.blue : UIColor.red
                owner.buttonColor.onNext(color)
                owner.buttonEnabled.onNext(value)
            }
            .disposed(by: disposeBag)
        
        
    }
    
}
