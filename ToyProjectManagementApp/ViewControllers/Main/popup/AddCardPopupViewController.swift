//
//  AddCardPopupViewController.swift
//  ToyProjectManagementApp
//
//  Created by 김정태 on 2022/10/13.
//

import Foundation
import UIKit
import Toast_Swift

class AddCardPopupViewController: UIViewController {
    
    @IBOutlet weak var popupTitleLabel: UILabel!
    @IBOutlet weak var addCardTextField: CustomTextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addCardButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    @IBAction func tapCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func tapAddCardButton(_ sender: UIButton) {
        
        if addCardTextField.text == ""{
            self.view.makeToast("카드 내용을 입력해주세요")
        } else {
            NotificationCenter.default.post(name: .addCardNotificaton, object: addCardTextField.text, userInfo: nil)
            self.dismiss(animated: true)
        }
    }
    
}


extension AddCardPopupViewController {
    private func configure() {
        self.configureCancelButton()
        self.configureCreateButton()
        self.configurePopupTitleLabel()
        self.configureAddCardTextField()
    }
    
    
    private func configurePopupTitleLabel() {
        self.popupTitleLabel.font = UIFont(name: "NanumGothicOTFBold", size: 16)
    }
    
    private func configureAddCardTextField() {
        self.addCardTextField.textFieldPlaceholder = "카드 이름을 입력해주세요"
    }
    
    private func configureCancelButton() {
        self.cancelButton.titleLabel?.font = UIFont(name: "NanumGothicOTF", size: 13)
        self.cancelButton.layer.cornerRadius = 8
    }
    
    private func configureCreateButton() {
        self.addCardButton.titleLabel?.font = UIFont(name: "NanumGothicOTF", size: 13)
        self.addCardButton.layer.cornerRadius = 8
    }
}
