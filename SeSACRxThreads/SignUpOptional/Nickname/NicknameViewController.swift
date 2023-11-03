//
//  NicknameViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class NicknameViewController: UIViewController {
   
    let nicknameTextField = SignTextField(placeholderText: "닉네임을 입력해주세요")
    let nextButton = PointButton(title: "다음")
    
    
    let nicknameStr = BehaviorSubject(value: "")
    let buttonHidden = BehaviorSubject(value: false)
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
       
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
        bind()

    }
    
    func bind() {
        
        // 1 - 1. nicknameStr -> nicknameTextField
        nicknameStr
            .bind(to: nicknameTextField.rx.text)
            .disposed(by: disposeBag)
        
        // 1 - 2. nicknameStr (count) -> buttonHidden
        nicknameStr
            .map { $0.count >= 2 && $0.count < 6 }
            .subscribe(with: self) { owner , value in
                owner.buttonHidden.onNext(!value)
            }
            .disposed(by: disposeBag)
        
        // 2. nicknameTextField -> nicknameStr
        nicknameTextField.rx.text
            .subscribe(with: self) { owner , value in
                owner.nicknameStr.onNext(value!)
            }
            .disposed(by: disposeBag)
        
        // 3. buttonHidden -> Button.rx.hidden?
        buttonHidden
            .bind(to: nextButton.rx.isHidden)
            .disposed(by: disposeBag)
        
    }
    
    
    
    
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(BirthdayViewController(), animated: true)
    }

    
    func configureLayout() {
        view.addSubview(nicknameTextField)
        view.addSubview(nextButton)
         
        nicknameTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
