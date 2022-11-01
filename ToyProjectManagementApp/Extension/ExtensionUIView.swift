//
//  ExtensionUIView.swift
//  ToyProjectManagementApp
//
//  Created by 김정태 on 2022/10/17.
//

import UIKit

extension UIView {
    static func animateCurveEaseOut(withDuration: TimeInterval, animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(
            withDuration: withDuration,
            delay: 0,
            usingSpringWithDamping: 1.1,
            initialSpringVelocity: 1,
            options: .curveEaseOut,
            animations: animations,
            completion: completion)
    }
    
    
    func loadXib() {
        // 1
        let identifier = String(describing: type(of: self))
        // 2
        let nibs = Bundle.main.loadNibNamed(identifier, owner: self, options: nil)
        // 3
        guard let customView = nibs?.first as? UIView else { return }
        // 4
        customView.frame = self.bounds
        // 5
        self.addSubview(customView)
    }
}

