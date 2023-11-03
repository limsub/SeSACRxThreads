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
    

    let disposeBag = DisposeBag()
    
    let viewModel = BirthdayViewModel()
    
    
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
            .bind(to: viewModel.birthDay) // 타입 동일해서 따로 map 해줄 필요 없다
            .disposed(by: disposeBag)
        
        
        
        
        
        
        // 3. year, month, day -> yearLabel, monthLabel, dayLabel
        viewModel.year    // (1). String으로 바꾸고(map) subscribe
            .observe(on: MainScheduler.instance)
            .map { "\($0) 년" }
            .subscribe(with: self) { owner , value in
                owner.yearLabel.text = value
            }
            .disposed(by: disposeBag)
        
        viewModel.month   // (2). 아예 값 넣어줄 때 형변환, subscribe
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner , value in
                owner.monthLabel.text = "\(value) 월"
            }
            .disposed(by: disposeBag)
        
        viewModel.day     // (3). bind 사용
            .map { "\($0) 일" }
            .bind(to: dayLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        // 4. buttonColor -> button backgroundColor
        viewModel.buttonColor
            .bind(to: nextButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        // 5. buttonEnabled -> button isenabled
        viewModel.buttonEnabled
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
