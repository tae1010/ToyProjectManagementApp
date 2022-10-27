//
//  ExtensionUIColor.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/09/15.
//

import Foundation
import UIKit

extension UIColor {

    // Primary color - (186, 153, 255, 100%)
    class var primaryColor: UIColor? { return UIColor(named: "primaryColor") }
    class var primaryCGColor: CGColor { return UIColor.primaryColor!.cgColor }
    
    
    // 밝기 여부 판단
    func isLight() -> Bool {
        guard let components = cgColor.components, components.count > 2 else { return false }
        let brightness = ((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000
        return (brightness > 0.5)
    }
    
}
