//
//  DetailColorContent.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/07/12.
//

import Foundation
import UIKit

// userDefault에 저장
// cardColor 내용저장

enum Color: String {
    case color0
    case color1
    case color2
    case color3
    case color4
    case color5
    case color6
    case color7
    case color8
    case color9
    case color10
    case color11
    case color12
    case color13
    case color14
    case color15
    
    var create: UIColor {
        switch self {
        case .color0:
            return UIColor.color0 ?? .white
        case .color1:
            return UIColor.color1 ?? .white
        case .color2:
            return UIColor.color2 ?? .white
        case .color3:
            return UIColor.color3 ?? .white
        case .color4:
            return UIColor.color4 ?? .white
        case .color5:
            return UIColor.color5 ?? .white
        case .color6:
            return UIColor.color6 ?? .white
        case .color7:
            return UIColor.color7 ?? .white
        case .color8:
            return UIColor.color8 ?? .white
        case .color9:
            return UIColor.color9 ?? .white
        case .color10:
            return UIColor.color10 ?? .white
        case .color11:
            return UIColor.color11 ?? .white
        case .color12:
            return UIColor.color12 ?? .white
        case .color13:
            return UIColor.color13 ?? .white
        case .color14:
            return UIColor.color14 ?? .white
        case .color15:
            return UIColor.color15 ?? .white
        }
    }
}
