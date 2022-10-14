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
    
    var moveContentDelegate: MoveContentDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
        print("2")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureView()
        print("3")
    }
    
    private func configureView() {
        //card color 테두리
        self.cardColor.layer.cornerRadius = 7.5
        
//        //cell 테두리
//        contentView.layer.borderWidth = 1
//        contentView.layer.borderColor = UIColor.lightGray.cgColor
//        contentView.layer.cornerRadius = 10
//        self.clipsToBounds = true
        
        //cell 그림자
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.shadowColor = UIColor.black.cgColor //색상
        self.contentView.layer.cornerRadius = 20
        self.contentView.layer.shadowOpacity = 0.2 //alpha값
        self.contentView.layer.shadowRadius = 1 //반경
        self.contentView.layer.shadowOffset = CGSize(width: 0, height: 1) //위치조정
        
    }
    
    
    
    
    @IBAction func moveContentLeftButton(_ sender: UIButton) {
        self.moveContentDelegate?.moveContentTapButton(cell: self, tag: sender.tag)
    }
    
    
    @IBAction func moveContentRightButton(_ sender: UIButton) {
        self.moveContentDelegate?.moveContentTapButton(cell: self, tag: sender.tag)
    }
    
}
