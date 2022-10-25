//
//  ChangeListTitlePopupViewController.swift
//  ToyProjectManagementApp
//
//  Created by 김정태 on 2022/10/21.
//

import Foundation
import UIKit

protocol ChangeListTitleDelegate: AnyObject {
    func changeListTitleDelegate(index: IndexPath, listTitle: String)
}

class ChangeListTitlePopupViewController: UIViewController {
    
    @IBOutlet weak var popupTitleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var changeListTitleButton: UIButton!
    
    @IBOutlet weak var changeListTitleTextField: CustomTextField!
    
    var clickListTitle: IndexPath?
    weak var changeListTitleDelegate: ChangeListTitleDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    @IBAction func tapCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func tapChangelistTitleButton(_ sender: Any) {
        if changeListTitleTextField.text == "" {
            self.view.makeToast("리스트 내용을 입력해주세요")
        } else {
            guard let changeListTitleTextField = self.changeListTitleTextField.text else { return }
            guard let clickListTitle = self.clickListTitle else { return }
            self.changeListTitleDelegate?.changeListTitleDelegate(index: clickListTitle, listTitle: changeListTitleTextField)
            self.dismiss(animated: true)
        }
    }
}

extension ChangeListTitlePopupViewController {
    
    private func configure() {
        self.configurePopupTitleLabel()
        self.configureChangeListTitleTextField()
        self.configureCancelButton()
        self.configureCreateButton()
    }
    
    private func configurePopupTitleLabel() {
        self.popupTitleLabel.font = UIFont(name: "NanumGothicOTFBold", size: 16)
    }
    
    private func configureChangeListTitleTextField() {
        self.changeListTitleTextField.textFieldPlaceholder = "리스트 이름을 입력해주세요"
    }
    
    private func configureCancelButton() {
        self.cancelButton.titleLabel?.font = UIFont(name: "NanumGothicOTF", size: 13)
        self.cancelButton.layer.cornerRadius = 8
    }
    
    private func configureCreateButton() {
        self.changeListTitleButton.titleLabel?.font = UIFont(name: "NanumGothicOTF", size: 13)
        self.changeListTitleButton.layer.cornerRadius = 8
    }
}
