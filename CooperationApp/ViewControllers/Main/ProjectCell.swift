//
//  ProjectCell.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/04/13.
//

import UIKit

class ProjectCell: UICollectionViewCell {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.contentView.layer.cornerRadius = 3.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.black.cgColor
    }
}
