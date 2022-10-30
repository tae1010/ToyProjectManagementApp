//
//  CreateProjectPopupViewController.swift
//  ToyProjectManagementApp
//
//  Created by 김정태 on 2022/09/30.
//

import Foundation
import UIKit
import MaterialComponents.MaterialBottomSheet

//변경된 카드 내용 전달 delegate
protocol CreateProjectDelegate: AnyObject{
    func createProject(title: String?)
}

class CreateProjectPopupViewController: UIViewController {
    
    @IBOutlet weak var popupTitle: UILabel!
    @IBOutlet weak var createProjectTextField: CustomTextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    
    weak var createProjectDelegate: CreateProjectDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    @IBAction func tapCancelButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func tabCreateButton(_ sender: UIButton) {
        self.createProjectDelegate?.createProject(title: createProjectTextField.text)
        dismiss(animated: true)
    }
}


// MARK: - configure
extension CreateProjectPopupViewController {
    
    private func configure() {
        self.configurePopupTitle()
        self.configureCreateProjectTextField()
        self.configureCancelButton()
        self.configureCreateButton()
    }
    
    private func configurePopupTitle() {
        self.popupTitle.font = UIFont(name: "NanumGothicOTFBold", size: 16)
    }
    
    private func configureCreateProjectTextField() {
        self.createProjectTextField.textFieldPlaceholder = "프로젝트 이름을 입력해주세요"
    }
    
    private func configureCancelButton() {
        self.cancelButton.titleLabel?.font = UIFont(name: "NanumGothicOTF", size: 13)
        self.cancelButton.layer.cornerRadius = 8
    }
    
    private func configureCreateButton() {
        self.createButton.titleLabel?.font = UIFont(name: "NanumGothicOTF", size: 13)
        self.createButton.layer.cornerRadius = 8
    }
}
