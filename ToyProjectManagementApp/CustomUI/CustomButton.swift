//
//  CustomButton.swift
//  ToyProjectManagementApp
//
//  Created by 김정태 on 2022/09/16.
//

import Foundation
import UIKit

class CustomButton: UIButton {
    
    // 메모리에 올라갈때 실행
    override init(frame: CGRect) {
        super.init(frame: frame)
        print(#fileID, #function, #line, "- ")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    convenience init(title: String = "no title", bgColor: UIColor? = .primaryColor, tintColor: UIColor = .white, cornerRadius: CGFloat = 8) {
        self.init(type: .system)
        self.setTitle(title, for: .normal)
        self.backgroundColor = bgColor
        self.tintColor = tintColor
        self.layer.cornerRadius = cornerRadius
    }
    
}
