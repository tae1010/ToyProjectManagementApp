//
//  AddListPopupViewController.swift
//  ToyProjectManagementApp
//
//  Created by 김정태 on 2022/10/13.
//

import Foundation
import UIKit
import Toast_Swift

class AddListPopupViewController: UIViewController {
    
    @IBOutlet weak var popupTitleLabel: UILabel!
    @IBOutlet weak var addListTextField: CustomTextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addListButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    @IBAction func tapCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func tapAddListButton(_ sender: Any) {
        
        if addListTextField.text == ""{
            self.view.makeToast("리스트 내용을 입력해주세요")
        } else {
            NotificationCenter.default.post(name: .addListNotificaton, object: addListTextField.text, userInfo: nil)
            self.dismiss(animated: true)
        }

    }

}

extension AddListPopupViewController {
    
    private func configure() {
        self.configureCancelButton()
        self.configureCreateButton()
        self.configurePopupTitleLabel()
        self.configureAddListTextField()
    }
    
    
    private func configurePopupTitleLabel() {
        self.popupTitleLabel.font = UIFont(name: "NanumGothicOTFBold", size: 16)
    }
    
    private func configureAddListTextField() {
        self.addListTextField.textFieldPlaceholder = "리스트 이름을 입력해주세요"
    }
    
    private func configureCancelButton() {
        self.cancelButton.titleLabel?.font = UIFont(name: "NanumGothicOTF", size: 13)
        self.cancelButton.layer.cornerRadius = 8
    }
    
    private func configureCreateButton() {
        self.addListButton.titleLabel?.font = UIFont(name: "NanumGothicOTF", size: 13)
        self.addListButton.layer.cornerRadius = 8
    }
}