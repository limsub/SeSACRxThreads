//
//  SampleViewController.swift
//  SeSACRxThreads
//
//  Created by 임승섭 on 2023/11/03.
//

import UIKit

class SampleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        title = "\(Int.random(in: 1...1000))"
    }
}
