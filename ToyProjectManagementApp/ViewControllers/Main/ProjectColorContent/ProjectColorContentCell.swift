//
//  ProjectColorContentCell.swift
//  ToyProjectManagementApp
//
//  Created by 김정태 on 2022/11/01.
//

import Foundation
import UIKit

class ProjectColorContentCell: UICollectionViewCell {

    
    @IBOutlet weak var checkMarkImageView: UIImageView!
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // initialize what is needed
        
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.contentView.layer.cornerRadius = 8.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
