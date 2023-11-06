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
