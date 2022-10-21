//
//  ProjectSideBarTableViewCell.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/08/01.
//

import UIKit

class ProjectSideBarTableViewCell: UITableViewCell {

    @IBOutlet weak var sideBarList: UILabel!
    @IBOutlet weak var currentPageCheckImageView: UIImageView!
    @IBOutlet weak var selectImageView: UIImageView!
    
    var select: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectImageView.isHidden = !selected

    }

}

extension ProjectSideBarTableViewCell {
    private func configureListLabel() {
        
    }
}
