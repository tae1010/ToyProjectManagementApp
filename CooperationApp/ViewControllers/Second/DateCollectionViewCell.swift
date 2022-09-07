//
//  DateCollectionViewCell.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/08/08.
//

import UIKit



class DateCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "DateCollectionViewCell"
    
    
    private lazy var dayLabel = UILabel()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
        self.configureStackView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
        self.configureStackView()
    }
    
//    override func prepareForReuse() {
//        self.dayLabel.text = nil
//    }
    
    func update(day: String) {
        self.dayLabel.text = day
    }
    
    private func configure() {
        self.addSubview(self.dayLabel)
        self.dayLabel.font = .boldSystemFont(ofSize: 12)
        self.dayLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.dayLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            self.dayLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
    }
    
    private func configureStackView() {
        
        let myStackView = UIStackView()
        myStackView.axis = .horizontal
        myStackView.alignment = .center
        myStackView.distribution = .fillEqually
        myStackView.spacing = 4
        contentView.addSubview(myStackView)
        
        //Setup circles
        let circle_1 = circleLabel()
        let circle_2 = circleLabel()
        let circle_3 = circleLabel()
        
        myStackView.addArrangedSubview(circle_1)
        myStackView.addArrangedSubview(circle_2)
        myStackView.addArrangedSubview(circle_3)
        
        myStackView.translatesAutoresizingMaskIntoConstraints = false
        myStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0.0).isActive = true
        myStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0.0).isActive = true
        
    }
    
    
    func circleLabel() -> UILabel {
        
        let label = UILabel()
        var width: CGFloat
        
        width = contentView.frame.width / 10
        label.backgroundColor = UIColor.red
        label.layer.cornerRadius = width / 2
        label.layer.masksToBounds = true
        
        label.widthAnchor.constraint(equalToConstant: width).isActive = true
        label.heightAnchor.constraint(equalToConstant: width).isActive = true
        
        return label
    }
    
}
