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
    
    // detailContentColor CollectionView에 cell backGround Color
    class var color0: UIColor? { return UIColor(named: "color0") }
    class var color0CGColor: CGColor { return UIColor.color0!.cgColor } // red
    
    class var color1: UIColor? { return UIColor(named: "color1") }
    class var color1CGColor: CGColor { return UIColor.color1!.cgColor } // orange
    
    class var color2: UIColor? { return UIColor(named: "color2") }
    class var color2CGColor: CGColor { return UIColor.color2!.cgColor } // yellow
    
    class var color3: UIColor? { return UIColor(named: "color3") }
    class var color3CGColor: CGColor { return UIColor.color3!.cgColor } // green
    
    class var color4: UIColor? { return UIColor(named: "color4") }
    class var color4CGColor: CGColor { return UIColor.color4!.cgColor }
    
    class var color5: UIColor? { return UIColor(named: "color5") }
    class var color5CGColor: CGColor { return UIColor.color5!.cgColor }
    
    class var color6: UIColor? { return UIColor(named: "color6") }
    class var color6CGColor: CGColor { return UIColor.color6!.cgColor }
    
    class var color7: UIColor? { return UIColor(named: "color7") }
    class var color7CGColor: CGColor { return UIColor.color7!.cgColor }
    
    class var color8: UIColor? { return UIColor(named: "color8") }
    class var color8CGColor: CGColor { return UIColor.color8!.cgColor } // blue
    
    class var color9: UIColor? { return UIColor(named: "color9") }
    class var color9CGColor: CGColor { return UIColor.color9!.cgColor } // dark blue
    
    class var color10: UIColor? { return UIColor(named: "color10") }
    class var color10CGColor: CGColor { return UIColor.color10!.cgColor } // purple
    
    class var color11: UIColor? { return UIColor(named: "color11") }
    class var color11CGColor: CGColor { return UIColor.color11!.cgColor } // black
    
    class var color12: UIColor? { return UIColor(named: "color12") }
    class var color12CGColor: CGColor { return UIColor.color12!.cgColor }
    
    class var color13: UIColor? { return UIColor(named: "color13") }
    class var color13CGColor: CGColor { return UIColor.color13!.cgColor }
    
    class var color14: UIColor? { return UIColor(named: "color14") }
    class var color14CGColor: CGColor { return UIColor.color14!.cgColor }
    
    class var color15: UIColor? { return UIColor(named: "color15") }
    class var color15CGColor: CGColor { return UIColor.color15!.cgColor }
    
    class var veryLightGray: UIColor? { return UIColor(named: "veryLightGray") }
    
    // 밝기 여부 판단
    func isLight() -> Bool {
        guard let components = cgColor.components, components.count > 2 else { return false }
        let brightness = ((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000
        return (brightness > 0.5)
    }
    
}
