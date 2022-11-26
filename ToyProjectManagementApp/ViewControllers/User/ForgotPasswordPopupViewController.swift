//
//  ForgotPasswordPopupViewController.swift
//  ToyProjectManagementApp
//
//  Created by 김정태 on 2022/11/24.
//

import Foundation
import UIKit
import FirebaseAuth
import Toast_Swift

protocol SendMessageDelegate: AnyObject {
    func sendMessageDelegate()
}

class ForgotPasswordPopupViewController: UIViewController {
    
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    @IBOutlet weak var forgotPasswordTextField: CustomTextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var resetPasswordButton: UIButton!
    
    weak var sendMessageDelegate: SendMessageDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    
    @IBAction func tabCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func tabResetPasswordButton(_ sender: UIButton) {
        
        if let email = self.forgotPasswordTextField.text {
            self.resetEmail(email: email)
        } else {
            self.view.hideAllToasts()
            self.view.makeToast("이메일을 적어주세요")
        }

    }
    
    // reset email
    private func resetEmail(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
            print(email)
            if error != nil {
                print("fail email \(error)")
                self.view.hideAllToasts()
                self.view.makeToast("잘못된 입력입니다")
            } else {
                self.dismiss(animated: true)
                self.sendMessageDelegate?.sendMessageDelegate()
                print("send email")
            }
        })
    }
}

extension ForgotPasswordPopupViewController {
    
    private func configure() {
        self.configureCancelButton()
        self.configureCreateButton()
        self.configurePopupTitleLabel()
        self.configureAddListTextField()
    }
    
    
    private func configurePopupTitleLabel() {
        self.forgotPasswordLabel.font = UIFont(name: "NanumGothicOTFBold", size: 16)
    }
    
    private func configureAddListTextField() {
        self.forgotPasswordTextField.textFieldPlaceholder = "비밀번호를 재설정할 이메일을 입력해주세요"
    }
    
    private func configureCancelButton() {
        self.cancelButton.titleLabel?.font = UIFont(name: "NanumGothicOTF", size: 13)
        self.cancelButton.layer.cornerRadius = 8
    }
    
    private func configureCreateButton() {
        self.resetPasswordButton.titleLabel?.font = UIFont(name: "NanumGothicOTF", size: 13)
        self.resetPasswordButton.layer.cornerRadius = 8
    }
}
