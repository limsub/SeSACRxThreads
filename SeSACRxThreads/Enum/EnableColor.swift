//
//  EnableColor.swift
//  SeSACRxThreads
//
//  Created by 임승섭 on 2023/11/03.
//

import UIKit

enum EnableColor {
    case red
    case blue

    var color: UIColor {
        switch self {
        case .red:
            return UIColor.red
        case .blue:
            return UIColor.blue
        }
    }
}
