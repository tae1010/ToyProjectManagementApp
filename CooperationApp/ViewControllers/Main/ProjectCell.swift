//
//  ProjectCell.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/04/13.
//

import UIKit

class ProjectCell: UICollectionViewCell {
    
    @IBOutlet weak var projectTitleLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    
    let r : CGFloat = CGFloat.random(in: 0.7...1)
    let g : CGFloat = CGFloat.random(in: 0.7...1)
    let b : CGFloat = CGFloat.random(in: 0.7...1)
    
    //cell 모양 설정(랜덤으로 샐의 색을 바뀌게 함)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.contentView.layer.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 0.2).cgColor
        self.contentView.layer.cornerRadius = 5.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor(red: r, green: g, blue: b, alpha: 1).cgColor
    }

}
