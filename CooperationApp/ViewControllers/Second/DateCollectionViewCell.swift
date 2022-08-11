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
    var check: Bool = false
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//    }
//
//    override func awakeFromNib() {
//        print(check)
//        self.contentView.backgroundColor = check ? .black : .white
//
//    }
//
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//    }

    // cell에 날짜 UI 설정
    func update(day: String?) {
        guard let day = day else { return }
        print(day,"데이")
        self.dateLabel.text = day
        self.dateLabel.font = UIFont.boldSystemFont(ofSize: 14)
    }
//
    func checkCurrentDate(_ check: Bool) {
        print("cehckCurrentDate 실행")
        if check == true {
            print("check는 true")
            self.contentView.backgroundColor = .black
            self.contentView.layer.cornerRadius = 5
        }
    }
    
    
    

}
