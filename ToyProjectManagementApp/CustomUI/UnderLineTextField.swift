//
//  UnderLineTextField.swift
//  ToyProjectManagementApp
//
//  Created by 김정태 on 2022/11/22.
//

import Foundation
import UIKit

class UnderLineTextField: UITextField {
    
    var padding: CGFloat = 15
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setUpUnderLineTextField()
    }
    
    func setUpUnderLineTextField() {
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width - 35, height: 1)
        bottomLayer.backgroundColor = UIColor.black.cgColor
        self.layer.addSublayer(bottomLayer)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        
        let bounds = CGRect(x: self.padding, y: 0 , width: bounds.width, height: bounds.height)
        
        return bounds
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        
        let bounds = CGRect(x:  self.padding, y: 0 , width: bounds.width, height: bounds.height)
        
        return bounds
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        
        let bounds = CGRect(x: self.padding, y: 0 , width: bounds.width, height: bounds.height)
        
        return bounds
    }
    
}
