//
//  ProjectContentTableViewCell.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/05/14.
//

import UIKit

protocol MoveContentDelegate: AnyObject {
    func moveContentTapButton(cell: UITableViewCell, tag: Int)
}

class ProjectContentTableViewCell: UITableViewCell {
    
    

    @IBOutlet weak var cardColor: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var moveContentDelegate: MoveContentDelegate?
    
    // cell이 랜더링(그릴떄) 될때
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCardColor()
        configureContentLabel()
        configureTimeLabel()
        configureContentView()
        
        self.layoutIfNeeded()
        print("2")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
//    @IBAction func moveContentLeftButton(_ sender: UIButton) {
//        self.moveContentDelegate?.moveContentTapButton(cell: self, tag: sender.tag)
//    }
}

// MARK: - configuration
extension ProjectContentTableViewCell {
    
    private func configureContentView() {
        self.layer.masksToBounds = true
        self.layer.borderWidth = 0.2
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func configureCardColor() {
        //card color 테두리
        self.cardColor.layer.cornerRadius = self.cardColor.frame.width / 2
    }
    
    private func configureContentLabel() {
        self.contentLabel.font = UIFont(name: "NanumGothicOTFExtraBold", size: 16)
    }
    
    private func configureTimeLabel() {
        self.timeLabel.font = UIFont(name: "NanumGothicOTFLight", size: 14)
    }
    
}
