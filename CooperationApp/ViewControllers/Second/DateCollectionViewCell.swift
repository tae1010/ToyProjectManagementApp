//
//  DateCollectionViewCell.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/08/08.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    var dateString: String?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        if let dateString = dateString {
            dateLabel.text = dateString
        }
        
    }

}
