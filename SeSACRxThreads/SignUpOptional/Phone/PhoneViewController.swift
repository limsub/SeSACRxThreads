//
//  PhoneViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PhoneViewController: UIViewController {
   
    let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    
    
    let phone = BehaviorSubject(value: "010")
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
        // 1. phone(Subject - String)과 텍스트필드의 텍스트 연결
        phone
            .bind(to: phoneTextField.rx.text)
            .disposed(by: disposeBag)
        
        // 2. buttonColor(Subject - UIColor)와 텍스트필드의 틴트컬러 및 보더컬러 연결
        buttonColor
            .bind(to: phoneTextField.rx.tintColor, nextButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        buttonColor
            .map { $0.cgColor }
            .bind(to: phoneTextField.layer.rx.borderColor)
            .disposed(by: disposeBag)
        
        /* 1, 2 코드만 본다면, 실제로 어떤 문자열인지, 어떤 색상인지 알 수 없다. 그냥 연결만 해줄 뿐이다 */
        
        
        // 3. phoneTextField의 텍스트와 phone 연결 (1번을 그대로 반대로 뒤집었다. 단 포맷팅을 해준다)
        phoneTextField.rx.text.orEmpty
            .subscribe { value in
                let result = value.formated(by: "###-####-####")
                print("전달받은 밸류 : \(value), 포맷팅한 리절트 : \(result)")
                self.phone.onNext(result)
            }
            .disposed(by: disposeBag)
        
        
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
                let color = value ? UIColor.blue : UIColor.red
                owner.buttonColor.onNext(color)
                owner.buttonEnabled.onNext(value)
            }
            .disposed(by: disposeBag)
        
        
        // 5. 버튼 색이 파란색일 때, 즉 enabled할 때 클릭이 가능하도록 한다
        buttonEnabled
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(NicknameViewController(), animated: true)
    }

    
    func configureLayout() {
        view.addSubview(phoneTextField)
        view.addSubview(nextButton)
         
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(phoneTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
