//
//  LogoImageView.swift
//  ToyProjectManagementApp
//
//  Created by 김정태 on 2022/09/17.
//

import Foundation
import UIKit

class LogoImageView: UILabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeImageView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initializeImageView()
    }
    
    private func initializeImageView() {
        
        self.layer.cornerRadius = 10
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 50),
            self.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1)
        ])
    }
}
