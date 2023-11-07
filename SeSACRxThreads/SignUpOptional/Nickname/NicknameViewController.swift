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

    let viewModel = NicknameViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
       
//        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
//        bind()
        
        bindDriver()

    }
    
    func bind() {
        
        // 1 - 1. nicknameStr -> nicknameTextField
        viewModel.nicknameStr
            .bind(to: nicknameTextField.rx.text)
            .disposed(by: disposeBag)
        
        
        // 2. nicknameTextField -> nicknameStr
        nicknameTextField.rx.text
            .subscribe(with: self) { owner , value in
                owner.viewModel.nicknameStr.onNext(value!)
            }
            .disposed(by: disposeBag)
        
        // 3. buttonHidden -> Button.rx.hidden?
        viewModel.buttonHidden
            .bind(to: nextButton.rx.isHidden)
            .disposed(by: disposeBag)
        
    }
    
    // 11/3 driver 사용해보기 (버튼 클릭 시 랜덤 숫자 방출)
    func bindDriver() {
        let tap = nextButton.rx.tap
            .map { "하이 \(Int.random(in: 1...1000))" }
            .asDriver(onErrorJustReturn: "")
            
        tap
            .drive(with: self) { owner , value in
            owner.nextButton.setTitle(value, for: .normal)
            }
            .disposed(by: disposeBag)
        
        tap
            .drive(with: self) { owner , value in
                owner.navigationItem.title = value
            }
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
