//
//  LogoLabel.swift
//  ToyProjectManagementApp
//
//  Created by 김정태 on 2022/09/17.
//

import Foundation
import UIKit

class LogoLabel: UILabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeLabel()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initializeLabel()
    }
    
    private func initializeLabel() {
        self.font = UIFont(name: "glogo", size: 40)
        self.text = "Toy"
        self.textColor = .primaryColor
    }
    
}
