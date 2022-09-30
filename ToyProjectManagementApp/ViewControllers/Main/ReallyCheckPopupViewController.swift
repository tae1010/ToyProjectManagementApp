//
//  ReallyCheckPopup.swift
//  ToyProjectManagementApp
//
//  Created by 김정태 on 2022/09/29.
//

import Foundation
import UIKit

// projectCollectionView 팝업창 버튼 delegate
protocol DeleteProjectDelegate : AnyObject{
    func deleteProject(index: Int, section: Int, tag: Int)
}

class ReallyCheckPopupViewController: UIViewController {
    
    @IBOutlet var backGroundView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var popupTitleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    weak var deleteCellDelegate: DeleteProjectDelegate?
    
    var cellIndex: Int = 0
    var section: Int = 0
    var tag: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        self.touchBackGround()
    }
    
    @IBAction func tapCancelButton(_ sender: UIButton) {
        
        self.dismiss(animated: true)
    }
    
    @IBAction func tapDeleteButton(_ sender: UIButton) {
        print(cellIndex, section, tag)
        self.deleteCellDelegate?.deleteProject(index: cellIndex, section: section, tag: tag)
        
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    private func touchBackGround() {
        let tabBackGroundView = UITapGestureRecognizer(target: self, action: #selector(tabBackGroundSelector))
        self.backGroundView.addGestureRecognizer(tabBackGroundView)
        self.backGroundView.isUserInteractionEnabled = true
    }
    
    // 백 그라운드 클릭시 팝업창 닫기
    @objc func tabBackGroundSelector(sender: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }
    
    
}

extension ReallyCheckPopupViewController {
    
    private func configure() {
        self.configureContentView()
        self.configurePopupTitleLabel()
        self.configureDeleteButton()
        self.configureCancelButton()
    }
    
    private func configureContentView() {
        self.contentView.layer.cornerRadius = 8
    }
    
    private func configurePopupTitleLabel() {
        self.popupTitleLabel.font = UIFont(name: "NanumGothicOTF", size: 14)
    }
    
    private func configureCancelButton() {
        self.cancelButton.titleLabel?.font = UIFont(name: "NanumGothicOTF", size: 14)
    }
    
    private func configureDeleteButton() {
        self.deleteButton.titleLabel?.font = UIFont(name: "NanumGothicOTF", size: 14)
    }
}
