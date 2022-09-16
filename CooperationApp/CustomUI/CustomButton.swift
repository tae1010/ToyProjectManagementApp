//
//  CustomButton.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/09/16.
//

import Foundation
import UIKit

class CustomButton: UIButton {
    
    init(inputLabelText: String) {
        self.init()
        self.initializeLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    private func initializeLabel() {
        
        
    }
    
    
}
