//
//  NotificationCell.swift
//  ToyProjectManagementApp
//
//  Created by 김정태 on 2022/11/08.
//

import Foundation
import UIKit


class NotificationCell: UITableViewCell {
    
    @IBOutlet weak var notificaionImageView: UIImageView!
    
    @IBOutlet weak var notificatioinProjectTitleLabel: UILabel!
    @IBOutlet weak var notificationContentLabel: UILabel!
    @IBOutlet weak var notificationDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureLabel()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension NotificationCell {
    private func configureLabel() {
        self.notificatioinProjectTitleLabel.font = UIFont(name: "NanumGothicOTFBold", size: 14)
        self.notificationContentLabel.font = UIFont(name: "NanumGothicOTFLight", size: 13)
        self.notificationDateLabel.font = UIFont(name: "NanumGothicOTFLight", size: 13)
    }
}
