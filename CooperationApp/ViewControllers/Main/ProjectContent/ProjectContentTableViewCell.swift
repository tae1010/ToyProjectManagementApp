//
//  ProjectContentTableViewCell.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/05/14.
//

import UIKit

class ProjectContentTableViewCell: UITableViewCell {

    @IBOutlet weak var content: UILabel!
    
    var topInset: CGFloat = 0
    var leftInset: CGFloat = 0
    var bottomInset: CGFloat = 0
    var rightInset: CGFloat = 0
    
    override func layoutMarginsDidChange() {
        super.layoutMarginsDidChange()
        self.layoutMargins = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.layer.cornerRadius = 5.0
        //self.contentView.layer.borderWidth = 1.0
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 5, right: 10))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
