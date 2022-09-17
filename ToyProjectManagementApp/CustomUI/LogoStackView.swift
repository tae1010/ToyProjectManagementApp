//
//  LogoStackView.swift
//  ToyProjectManagementApp
//
//  Created by 김정태 on 2022/09/17.
//

import Foundation
import UIKit

class LogoStackView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder: NSCoder) has not been implemented")
    }
    
    func configure() {
        let logoImageView: LogoImageView
        let logoLabel: LogoLabel
        
        self.spacing = 4
        self.alignment = .bottom
        self.axis = .horizontal
        self.distribution = .fill
        self.addArrangedSubview(logoImageView)
        self.addArrangedSubview(logoLabel)
    }
    func bind() {}
    
    
}
