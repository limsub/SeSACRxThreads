//
//  SearchViewController.swift
//  SeSACRxThreads
//
//  Created by 임승섭 on 2023/11/03.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    
    private let tableView: UITableView =  {
        let view = UITableView()
        view.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        view.backgroundColor = .white
        view.rowHeight = 200
        view.separatorStyle = .none
        return view
    }()
    
    let searchBar = UISearchBar()
    
    var data = ["a", "abcd", "abaaa", "ababab", "def", "f", "de"]
    
    lazy var items = BehaviorSubject(value: data)
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configure()
        setSearchController()
        bind()
        bindSearchBar()
    }
    
    func bind() {
        
        // cellForRowAt
        items.bind(to: tableView.rx.items(
                        cellIdentifier: SearchTableViewCell.identifier,
                        cellType: SearchTableViewCell.self
        )) { (row, element, cell) in
            cell.appNameLabel.text = element
            cell.appIconImageView.backgroundColor = .green
            
            cell.downloadButton.rx.tap
                .subscribe(with: self) { owner , value in
                    owner.navigationController?.pushViewController(SampleViewController(), animated: true)
                }
                .disposed(by: cell.disposeBag)
        }
        .disposed(by: disposeBag)
        
        
        // 셀 선택 시 액션 (11/3)
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(String.self))
            .map { "셀 선택 \($0) \($1)" }
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
    }
    
    func bindSearchBar() {
        // 테이블뷰 데이터 추가
        searchBar.rx.searchButtonClicked
            .withLatestFrom(searchBar.rx.text.orEmpty) { _, text  in
                // searchButtonClicked -> _
                // searchBar.rx.text.orEmpty -> text
                return text
            }
            .subscribe(with: self) { owner , text  in
                print("서치 버튼 셀렉트 : \(text)")
                
                // data 배열을 따로 만들었던 이유
                // BehaviorSubject인 items에서도 value를 꺼내올 수는 있지만, 그러면 try 구문을 사용해야 한다
                    // items.value()
                owner.data.insert(text, at: 0)
                owner.items.onNext(owner.data)
            }
            .disposed(by: disposeBag)
        
        
        // 실시간 검색
        // 매번 계속 네트워크 통신을 하는 건 불필요 -> debounce 이용해서 커서가 멈추고 몇 초 후 실행
        searchBar.rx.text.orEmpty
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(with: self) { owner , value in
                let result = value == "" ? owner.data : owner.data.filter { $0.contains(value) }
                owner.items.onNext(result)
                print("실시간 검색 === \(result)")
            }
            .disposed(by: disposeBag)
    }

    
    private func setSearchController() {
        view.addSubview(searchBar)
        self.navigationItem.titleView = searchBar
    }

    
    private func configure() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

    }
}
