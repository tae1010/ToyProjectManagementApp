//
//  ProjectCell.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/04/13.
//

import UIKit

//protocol ImportantCheckDelegate: AnyObject {
//    func imporantButtonTap(cell: UICollectionViewCell)
//}

class ProjectCell: UICollectionViewCell {
    
    @IBOutlet weak var projectTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var importantImageView: UIImageView!
    
//    var cellDelegate: ImportantCheckDelegate? // important button delegate
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // initialize what is needed
        
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureImageView()
        self.configureProjectTitleLabel()
        self.configureDateLabel()
        self.contentView.layer.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1).cgColor
        self.contentView.layer.cornerRadius = 8.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1).cgColor

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.tapImageView()
    }
    
    private func configureProjectTitleLabel() {
        if self.projectTitleLabel != nil {
            self.projectTitleLabel.font = UIFont(name: "NanumGothicOTFBold", size: 14)
        }
    }
    
    private func configureDateLabel() {
        if self.dateLabel != nil {
            self.dateLabel.font = UIFont(name: "NanumGothicOTFLigit", size: 12)
        }
    }
    
    private func configureImageView() {
        if let imageView = self.importantImageView {
            imageView.image = UIImage(named: "customStar")
        }
    }

}
