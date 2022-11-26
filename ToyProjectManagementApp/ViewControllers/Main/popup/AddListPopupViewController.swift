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
    @IBOutlet weak var specialSymbolLabel: UILabel!
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
        let addListText = addListTextField.text ?? ""
        
        
        if addListText == "" {
            self.view.hideAllToasts()
            self.view.makeToast("리스트 내용을 입력해주세요")
            
        } else if findSpecialSymbol(changeListTitleText: addListText){
            self.view.hideAllToasts()
            self.view.makeToast(". # $ [ ] 기호를 사용할 수 없습니다")
            
        } else {
            NotificationCenter.default.post(name: .addListNotificaton, object: addListTextField.text, userInfo: nil)
            self.dismiss(animated: true)
        }

    }
    
    // 특수기호 판별
    private func findSpecialSymbol(changeListTitleText: String) -> Bool{
        for i in changeListTitleText {
            if i == "." || i == "#" || i == "$" || i == "[" || i == "]" {
                return true
            }
        }
        return false
    }

}

extension AddListPopupViewController {
    
    private func configure() {
        self.configureCancelButton()
        self.configureCreateButton()
        self.configureSpecialSymbolLabel()
        self.configurePopupTitleLabel()
        self.configureAddListTextField()
    }
    
    
    private func configurePopupTitleLabel() {
        self.popupTitleLabel.font = UIFont(name: "NanumGothicOTFBold", size: 16)
    }
    
    private func configureAddListTextField() {
        self.addListTextField.textFieldPlaceholder = "리스트 이름을 입력해주세요"
    }
    
    private func configureSpecialSymbolLabel() {
        self.specialSymbolLabel.font = UIFont(name: "NanumGothicOTFLight", size: 13)
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
