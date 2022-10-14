//
//  ProjectHeaderView.swift
//  ToyProjectManagementApp
//
//  Created by 김정태 on 2022/10/10.
//

import UIKit

class ProjectHeaderView: UIView {
    
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
    }


}
