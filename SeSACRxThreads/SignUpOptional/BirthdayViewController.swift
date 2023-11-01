//
//  BirthdayViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BirthdayViewController: UIViewController {
    
    let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    let infoLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.text = "만 17세 이상만 가입 가능합니다."
        return label
    }()
    
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10 
        return stack
    }()
    
    let yearLabel: UILabel = {
       let label = UILabel()
        label.text = "2023년"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let monthLabel: UILabel = {
       let label = UILabel()
        label.text = "33월"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let dayLabel: UILabel = {
       let label = UILabel()
        label.text = "99일"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
  
    let nextButton = PointButton(title: "가입하기")
    
    
    
    let birthDay: BehaviorSubject<Date> = BehaviorSubject(value: .now)
    let year = BehaviorSubject(value: 2020)
    let month = BehaviorSubject(value: 12)
    let day = BehaviorSubject(value: 22)
    
    let buttonColor = BehaviorSubject(value: UIColor.red)
    let buttonEnabled = BehaviorSubject(value: false)
    
    let disposeBag = DisposeBag()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
        bind()
    }
    
    func bind() {
        
        // 1. DatePicker의 선택 값 -> birthDay에 전달
        birthDayPicker.rx.date
            .bind(to: birthDay) // 타입 동일해서 따로 map 해줄 필요 없다
            .disposed(by: disposeBag)
        
        
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
        
        
        
        // 3. year, month, day -> yearLabel, monthLabel, dayLabel
        year    // (1). String으로 바꾸고(map) subscribe
            .observe(on: MainScheduler.instance)
            .map { "\($0) 년" }
            .subscribe(with: self) { owner , value in
                owner.yearLabel.text = value
            }
            .disposed(by: disposeBag)
        
        month   // (2). 아예 값 넣어줄 때 형변환, subscribe
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner , value in
                owner.monthLabel.text = "\(value) 월"
            }
            .disposed(by: disposeBag)
        
        day     // (3). bind 사용
            .map { "\($0) 일" }
            .bind(to: dayLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        // 4. buttonColor -> button backgroundColor
        buttonColor
            .bind(to: nextButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        // 5. buttonEnabled -> button isenabled
        buttonEnabled
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
    }
    
    @objc func nextButtonClicked() {
        print("가입완료")
    }

    
    func configureLayout() {
        view.addSubview(infoLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
 
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
   
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
