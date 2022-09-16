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
    @IBOutlet weak var editModeStackView: UIStackView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    var moveContentDelegate: MoveContentDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    private func configureView() {
        //card color 테두리
        self.cardColor.layer.cornerRadius = 5
        
        //cell 테두리
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.cornerRadius = 10
        
        //cell 그림자
        self.contentView.layer.shadowColor = UIColor.black.cgColor //색상
        self.contentView.layer.shadowOpacity = 0.2 //alpha값
        self.contentView.layer.shadowRadius = 1 //반경
        self.contentView.layer.shadowOffset = CGSize(width: 0, height: 1) //위치조정
        self.contentView.layer.masksToBounds = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0))
    }
    
    
    @IBAction func moveContentLeftButton(_ sender: UIButton) {
        self.moveContentDelegate?.moveContentTapButton(cell: self, tag: sender.tag)
    }
    
    
    @IBAction func moveContentRightButton(_ sender: UIButton) {
        self.moveContentDelegate?.moveContentTapButton(cell: self, tag: sender.tag)
    }
    
}
