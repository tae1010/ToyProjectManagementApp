//
//  ChangeProjectTitlePopupViewController.swift
//  ToyProjectManagementApp
//
//  Created by 김정태 on 2022/11/04.
//

import Foundation
import UIKit
import Toast_Swift

class ChangeProjectTitlePopupViewController: UIViewController {
    
    @IBOutlet weak var changeProjectTitleLabel: UILabel!
    @IBOutlet weak var changeProjectTitleTextField: CustomTextField!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var changeProjectTitleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    @IBAction func tapCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func tapChangeProjectTitleButton(_ sender: Any) {
        
        if self.changeProjectTitleTextField.text == ""  {
            self.view.hideToast()
            self.view.makeToast("프로젝트 이름을 적어주세요",duration: 0.5)
            return
        } else {
            NotificationCenter.default.post(name: .changeProjectTitleNotification, object: self.changeProjectTitleTextField.text, userInfo: nil)
            self.dismiss(animated: true)
        }

    }
}


extension ChangeProjectTitlePopupViewController {
    
    private func configure() {
        self.configureChangeProjectTitleLabel()
        self.configureChangeProjectTitleTextField()
        self.configureCancelButton()
        self.configureChangeProjectTitleButton()
    }
    
    private func configureChangeProjectTitleLabel() {
        self.changeProjectTitleLabel.font = UIFont(name: "NanumGothicOTFBold", size: 16)
    }
    
    private func configureChangeProjectTitleTextField() {
        self.changeProjectTitleTextField.textFieldPlaceholder = "프로젝트 이름을 입력해주세요"
    }
    
    private func configureCancelButton() {
        self.cancelButton.titleLabel?.font = UIFont(name: "NanumGothicOTF", size: 13)
        self.cancelButton.layer.cornerRadius = 8
    }
    
    private func configureChangeProjectTitleButton() {
        self.changeProjectTitleButton.titleLabel?.font = UIFont(name: "NanumGothicOTF", size: 13)
        self.changeProjectTitleButton.layer.cornerRadius = 8
    }
}
