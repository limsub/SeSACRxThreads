//
//  SignInViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SignInViewController: UIViewController {

    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let signInButton = PointButton(title: "로그인")
    let signUpButton = UIButton()
    
    // 11/1 UISwitch와 isOn 변수
    let test = UISwitch()

    let disposeBag = DisposeBag()
    
    // 11/2 viewModel 분리
    let viewModel = SignInViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        testSwitch()

        view.backgroundColor = Color.white
        
        configureLayout()
        configure()
        
        signUpButton.addTarget(self, action: #selector(signUpButtonClicked), for: .touchUpInside)
        
        bind()
//        testCombineLatest()
    }
    
    
    // 11/2 (combineLatest 학습)
    func bind() {
        let email = emailTextField.rx.text.orEmpty
        let password = passwordTextField.rx.text.orEmpty
        
        // 두 개를 하나로 엮는다
        let validation = Observable.combineLatest(email, password) { first , second in
            return true // first.count > 8 && second.count > 6
        }
        
        validation
            .bind(to: signInButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        validation
            .subscribe(with: self) { owner , value in
                owner.signInButton.backgroundColor = value ? UIColor.blue : UIColor.red
                owner.emailTextField.layer.borderColor = value ? UIColor.blue.cgColor : UIColor.red.cgColor
                owner.passwordTextField.layer.borderColor = value ? UIColor.blue.cgColor : UIColor.red.cgColor
            }
            .disposed(by: disposeBag)
        
        
        signInButton.rx.tap
            .subscribe(with: self) { owner , value in
                print("SELECT, 화면 전환")
                owner.navigationController?.pushViewController(SearchViewController(), animated: true)
            }
    }
    
    // 11/2 (combineLatest + 초기값 유무)
    func testCombineLatest() {
        let a = PublishSubject<Int>() //BehaviorSubject(value: 2)
        let b = PublishSubject<String>() //BehaviorSubject(value: "가")
        
        
//        a.bind(to: <#T##Int...##Int#>)
        
        Observable.combineLatest(a, b) { first , second in
            return "결과 : \(first) & \(second)"
        }
        .subscribe(with: self) { owner , value in
            print(value)
        }
        .disposed(by: disposeBag)
        
        a.onNext(100)
        a.onNext(200)
        a.onNext(300)
        
        b.onNext("감")
        b.onNext("남")
        b.onNext("담")
    }
    
    // 11/1
    func testSwitch() {
        view.addSubview(test)
        test.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(150)
            make.centerX.equalTo(view)
        }
        
        /* ==== 스위치(UI) ===== */
        // 1. 기존 UIKit 방식
//        test.setOn(true, animated: true)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            self.test.setOn(false, animated: true)  // 3초 후, false로 바꿔줘
//        }
        
        // 2. RxSwift (isOn 변수와 subscribe + onNext) - 내부 클로저 형태는 결국 UIKit 형태
//        isOn
//            .subscribe { value in
//                self.test.setOn(value, animated: true)
//            }
//            .disposed(by: disposeBag)
        
        // 3. RxSwift (isOn 변수와 bind + to) - RxCocoa 형태로 활용
        viewModel.isOn
            .bind(to: test.rx.isOn)
            .disposed(by: disposeBag)
        
        
        /* PublishSubject는 초기값이 없기 때문에 "구독" 후, 값을 전달해준다 */
        viewModel.isOn.onNext(true)
        
        
        /* 이제 UI 객체에 직접적으로 접근하는게 아니라, isOn이라는 변수를 이용한다 */
        // 만약 isOn을 Observable로 선언했다면, 값을 바꿔줄 수가 없다 -> Subject 활용
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.viewModel.isOn.onNext(false)
        }
        
    }
    
    @objc func signUpButtonClicked() {
        navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    
    
    func configure() {
        signUpButton.setTitle("회원이 아니십니까?", for: .normal)
        signUpButton.setTitleColor(Color.black, for: .normal)
    }
    
    func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signInButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(signInButton.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    

}
