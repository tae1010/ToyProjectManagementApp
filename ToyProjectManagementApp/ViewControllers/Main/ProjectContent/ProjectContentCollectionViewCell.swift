//
//  ProjectContentCellCollectionViewCell.swift
//  ToyProjectManagementApp
//
//  Created by 김정태 on 2022/10/11.
//

import UIKit

class ProjectContentCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var originalView: UIView!
    @IBOutlet weak var settingView: UIView!
    
    @IBOutlet weak var color1: UIView!

    @IBOutlet weak var cardLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configure()
        
    }
    
    @IBAction func tapMoveLeftButton(_ sender: UIButton) {
    }
    
    @IBAction func tapMoveRightButton(_ sender: UIButton) {
    }
    
    @IBAction func tapDeleteButton(_ sender: UIButton) {
    }
    
}

// MARK: - configureation
extension ProjectContentCollectionViewCell {
    
    private func configure() {
        self.configureColorView()
        self.configureCardLabel()
        self.configureSettingView()
        self.configureCellView()
        self.configureOriginalView()
        self.configureColorView()
        self.configureContentView()
    }

    private func configureContentView() {
        if let settingView = self.settingView {
            settingView.isHidden = true
        }
    }
    
    private func configureColorView() {
        if let colorView = self.color1 {
            colorView.layer.cornerRadius = 20
        }
        
    }

    
    private func configureCardLabel() {
        
        if let cardLabel = self.cardLabel {
            cardLabel.font = UIFont(name: "NanumGothicOTFBold", size: 16)
            cardLabel.frame.size = cardLabel.intrinsicContentSize
        }
       
    }
    
    private func configureOriginalView() {
        if let originalView = self.originalView {
            originalView.layer.cornerRadius = 20
        }
    }
    
    private func configureSettingView() {
        
        if let settingView = self.settingView {
            
            settingView.layer.cornerRadius = 20
            settingView.layer.masksToBounds = true
            
            settingView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
            
        }
    }
    
    private func configureCellView() {
        
        //cell 그림자
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: -2, height: 4)
        self.layer.shadowRadius = 1

    }
    
    
}
