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
    
    
    let viewModel = PhoneViewModel()
    
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
        viewModel.phone
            .bind(to: phoneTextField.rx.text)
            .disposed(by: disposeBag)
        
        // 2. buttonColor(Subject - UIColor)와 텍스트필드의 틴트컬러 및 보더컬러 연결
        viewModel.buttonColor
            .bind(to: phoneTextField.rx.tintColor, nextButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        viewModel.buttonColor
            .map { $0.cgColor }
            .bind(to: phoneTextField.layer.rx.borderColor)
            .disposed(by: disposeBag)
        
        /* 1, 2 코드만 본다면, 실제로 어떤 문자열인지, 어떤 색상인지 알 수 없다. 그냥 연결만 해줄 뿐이다 */
        
        
        // 3. phoneTextField의 텍스트와 phone 연결 (1번을 그대로 반대로 뒤집었다. 단 포맷팅을 해준다)
        phoneTextField.rx.text.orEmpty
            .subscribe(with: self) { owner , value in
                let result = value.formated(by: "###-####-####")
                print("전달받은 밸류 : \(value), 포맷팅한 리절트 : \(result)")
                owner.viewModel.phone.onNext(result)
            }
            .disposed(by: disposeBag)
        
        
        // 5. 버튼 색이 파란색일 때, 즉 enabled할 때 클릭이 가능하도록 한다
        viewModel.buttonEnabled
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
