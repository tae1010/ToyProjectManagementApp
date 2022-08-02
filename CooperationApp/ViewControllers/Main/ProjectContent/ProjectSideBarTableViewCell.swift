//
//  ProjectSideBarTableViewCell.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/08/01.
//

import UIKit

class ProjectSideBarTableViewCell: UITableViewCell {

    @IBOutlet weak var sideBarList: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
