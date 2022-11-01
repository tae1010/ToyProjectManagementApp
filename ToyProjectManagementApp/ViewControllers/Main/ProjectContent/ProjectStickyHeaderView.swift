//
//  ProjectStickyHeaderView.swift
//  ToyProjectManagementApp
//
//  Created by 김정태 on 2022/10/11.
//

import Foundation
import UIKit

class ProjectStickyHeaderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    func configureView() {
        self.layer.cornerRadius = 20
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
}
