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
    
    @IBOutlet weak var eventVStackView: UIStackView!
    
    @IBOutlet weak var eventHStackView: UIStackView!
    
    @IBOutlet weak var eventView_V1: UIView!
    @IBOutlet weak var eventView_V2: UIView!
    @IBOutlet weak var eventView_V3: UIView!
    
    @IBOutlet weak var event1: UILabel!
    @IBOutlet weak var event2: UILabel!
    @IBOutlet weak var event3: UILabel!
    
    @IBOutlet weak var eventView_H1: UIView!
    @IBOutlet weak var eventView_H2: UIView!
    @IBOutlet weak var eventView_H3: UIView!
    
    let myStackView = UIStackView()
    var myStackViewWidth = 0.0

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureHStack()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //self.configureHStack()
    }
    
    // cell에 날짜 UI 설정
    func update(day: String?) {
        guard let day = day else { return }
        self.dateLabel.text = day
        self.dateLabel.font = UIFont.boldSystemFont(ofSize: 14)
        
    }
    
    // 오늘 날짜 cell ui 설정 (true면 오늘)
    func checkCurrentDate(_ check: Bool) {
        if check == true {
            self.dateLabel.backgroundColor = .black
            self.dateLabel.textColor = .white
            self.dateLabel.layer.cornerRadius = 5
        } else {
            self.dateLabel.backgroundColor = .white
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
    
    // calendarMode 변경시 보여지는 eventStackView
    func calendarMode(_ calendarMode: CalendarMode) {
        if calendarMode == .fullMonth {
            self.configureVStack()
            

        } else {

            self.configureHStack()
        }
        
        self.contentView.layoutIfNeeded()
    }
    
    // week, half Month 상태일때 기본으로 설정되어 있는 eventStackView
    private func configureHStack() {
        eventVStackView.translatesAutoresizingMaskIntoConstraints = false
        eventVStackView.axis = .horizontal
        eventVStackView.alignment = .center
        eventVStackView.distribution = .fillEqually
        eventVStackView.spacing = 2
        
        [event1, event2, event3].forEach({
            $0?.text = " "
            $0?.backgroundColor = UIColor.red
            $0?.layer.cornerRadius = 3
            $0?.layer.masksToBounds = true
            $0?.widthAnchor.constraint(equalToConstant: 6.0).isActive = true
            $0?.heightAnchor.constraint(equalToConstant: 6.0).isActive = true
        })

    }
    
    // full Month 상태일때 기본으로 설정되어 있는 eventStackView
    private func configureVStack() {
        
        eventVStackView.translatesAutoresizingMaskIntoConstraints = false
        eventVStackView.axis = .vertical
        eventVStackView.alignment = .fill
        eventVStackView.distribution = .fillEqually

        [event1, event2, event3].forEach({
            $0?.text = "asss"
            $0?.layer.cornerRadius = 1
            $0?.backgroundColor = .yellow
            
        })
        
    }
    
    
}

