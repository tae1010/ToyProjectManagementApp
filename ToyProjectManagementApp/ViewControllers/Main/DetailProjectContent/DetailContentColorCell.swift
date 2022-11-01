//
//  DetailContentColorCell.swift
//  ToyProjectManagementApp
//
//  Created by 김정태 on 2022/10/31.
//

import Foundation
import UIKit

class DetailContentColorCell: UICollectionViewCell {

    
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
