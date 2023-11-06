//
//  PasswordViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PasswordViewController: UIViewController {
   
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
         
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
//        aboutUnicast()
//        aboutMulticast()
        requestExample()
    }
    
    // 11/6 unicast and multicast
    func aboutUnicast() {
//        let r = Observable.of(Int.random(in: 1...100))
//        let dis = r
//            .subscribe(with: self) { owner , value in
//                print("rrr", value)
//            }
//
        
        let random = Observable<Int>.create { value in  // 새로운 operator를 만든다
            value.onNext(Int.random(in: 1...100))
            return Disposables.create()
        }
        
        random
            .subscribe(with: self) { owner , value in
                print("u", value)
            }
            .disposed(by: disposeBag)
        random
            .subscribe(with: self) { owner , value in
                print("u", value)
            }
            .disposed(by: disposeBag)
        random
            .subscribe(with: self) { owner , value in
                print("u", value)
            }
            .disposed(by: disposeBag)
    }
    
    func aboutMulticast() {
        let random = BehaviorSubject(value: 100)
        
        random.onNext(Int.random(in: 1...100))
        
        random
            .subscribe(with: self) { owner , value in
                print("m", value)
            }
            .disposed(by: disposeBag)
        random
            .subscribe(with: self) { owner , value in
                print("m", value)
            }
            .disposed(by: disposeBag)
        random
            .subscribe(with: self) { owner , value in
                print("m", value)
            }
            .disposed(by: disposeBag)
    }
    
    func requestExample() {
        let request = BasicAPIManager.fetchData().share()
        
        request.subscribe(with: self) { owner , value in
            print("1")
        }
        .disposed(by: disposeBag)
        
        request.subscribe(with: self) { owner , value in
            print("2")
        }
        .disposed(by: disposeBag)
        
        request.subscribe(with: self) { owner , value in
            print("3")
        }
        .disposed(by: disposeBag)
    }
    
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(PhoneViewController(), animated: true)
    }
    
    func configureLayout() {
        view.addSubview(passwordTextField)
        view.addSubview(nextButton)
         
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
