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

    // cell에 날짜 UI 설정
    func update(day: String?) {
        guard let day = day else { return }
        self.dateLabel.text = day
        self.dateLabel.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    // 오늘 날짜 cell ui 설정 
    func checkCurrentDate(_ check: Bool) {
        if check == true {
            self.contentView.backgroundColor = .black
            self.dateLabel.textColor = .white
            self.contentView.layer.cornerRadius = 5
        } else {
            self.contentView.backgroundColor = .white
            self.dateLabel.textColor = .black
        }
    }
    
    // 선택된 cell ui 설정
    func selectCell(_ select: Bool) {
        if select == true {
            self.contentView.backgroundColor = .lightGray
            self.contentView.alpha = 0.8
        } else {
            self.contentView.backgroundColor = .white
        }
    }
}

