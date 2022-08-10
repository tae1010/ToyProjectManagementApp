//
//  DateCollectionViewCell.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/08/08.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellBackground: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    var check: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // cell에 날짜 UI 설정
    func update(day: String?) {
        guard let day = day else { return }
        self.dateLabel.text = day
        self.dateLabel.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    

}
