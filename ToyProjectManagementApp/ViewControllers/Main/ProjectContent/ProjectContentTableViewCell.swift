//
//  ProjectContentTableViewCell.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/05/14.
//

import UIKit
import DropDown
import Toast_Swift

protocol MakeToastMessage: AnyObject {
    func makeToastMessage()
}

protocol MoveContentDelegate: AnyObject {
    func moveContentTapButton(cell: UITableViewCell, listIndex: Int)
}

class ProjectContentTableViewCell: UITableViewCell {

    @IBOutlet weak var cardColor: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var moveCardButton: UIButton!
    
    let dropDown = DropDown() // dropdown 객체
    
    var moveContentDelegate: MoveContentDelegate?
    
    var makeToastMessage: MakeToastMessage?
    var projectListArray = [ProjectContent]()
    
    // cell이 랜더링(그릴떄) 될때
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCardColor()
        configureContentLabel()
        configureTimeLabel()
        configureContentView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @IBAction func tapMoveCardButton(_ sender: UIButton) {
        self.configureDropDown()
        self.makeToastMessage?.makeToastMessage()

        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.moveContentDelegate?.moveContentTapButton(cell: self, listIndex: index)
            self.dropDown.clearSelection()
        }
    }
    
    private func configureDropDown() {
        dropDown.dataSource = self.inputDropDownData(projectContent: projectListArray) // dropdown data
        
        // dropdown 위치
        dropDown.anchorView = self.moveCardButton
        dropDown.bottomOffset = CGPoint(x: -40, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.width = 150
        dropDown.textColor = UIColor.black
        dropDown.selectedTextColor = UIColor.red
        dropDown.textFont = UIFont(name: "NanumGothicOTF", size: 14) ?? UIFont.systemFont(ofSize: 14)
        dropDown.backgroundColor = UIColor.white
        dropDown.selectionBackgroundColor = UIColor.white
        dropDown.cornerRadius = 5
        
        dropDown.show()
    }
    
    private func inputDropDownData(projectContent: [ProjectContent]) -> [String] {
        
        var projectList = [String]()
        
        projectContent.forEach({
            projectList.append($0.listTitle)
        })
        
        return projectList
        
    }

}

// MARK: - configuration
extension ProjectContentTableViewCell {
    
    private func configureContentView() {
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = 0.5
        self.layer.cornerRadius = 20
        self.layer.shadowColor = UIColor.black.cgColor
    }
    
    private func configureCardColor() {
        //card color 테두리
        self.cardColor.layer.cornerRadius = self.cardColor.frame.width / 2
    }
    
    private func configureContentLabel() {
        self.contentLabel.font = UIFont(name: "NanumGothicOTFExtraBold", size: 16)
    }
    
    private func configureTimeLabel() {
        self.timeLabel.font = UIFont(name: "NanumGothicOTFLight", size: 12)
    }
    
}
