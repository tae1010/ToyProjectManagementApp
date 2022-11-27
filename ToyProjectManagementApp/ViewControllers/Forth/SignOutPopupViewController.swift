//
//  SighOutPopupViewController.swift
//  ToyProjectManagementApp
//
//  Created by 김정태 on 2022/11/13.
//

import Foundation
import UIKit

protocol LogoutDelegate: AnyObject {
    func logoutDelegate()
}

class SignOutPopupViewController: UIViewController {
    
    @IBOutlet var backGroundView: UIView!
    @IBOutlet weak var popupTitleLabel: UILabel!
    @IBOutlet weak var popupContentLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    
    weak var logoutDelegate: LogoutDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        self.touchBackGround()
    }
    

    @IBAction func tapCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    // 뒤로가서 delegate패턴으로 로그아웃
    @IBAction func tapSignOutButton(_ sender: UIButton) {
        self.logoutDelegate?.logoutDelegate()
        UserDefault().removeNotificationModelUserDefault()
        self.dismiss(animated: true)
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

extension SignOutPopupViewController {
    
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
        self.popupContentLabel.font = UIFont(name: "NanumGothicOTFLight", size: 12)
    }
    
    private func configureCancelButton() {
        self.cancelButton.titleLabel?.font = UIFont(name: "NanumGothicOTF", size: 14)
    }
    
    private func configureDeleteButton() {
        self.signOutButton.titleLabel?.font = UIFont(name: "NanumGothicOTF", size: 14)
    }
}
