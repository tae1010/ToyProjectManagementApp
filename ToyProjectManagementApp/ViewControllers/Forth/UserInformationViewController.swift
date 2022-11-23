//
//  UserInformationViewController.swift
//  ToyProjectManagementApp
//
//  Created by 김정태 on 2022/11/22.
//

import Foundation
import UIKit
import FirebaseDatabase
import Firebase
import FirebaseAuth
import Toast_Swift
import KakaoSDKUser

protocol MessageDelegate: AnyObject {
    func messageDelegate()
}

class UserInformationViewController: UIViewController {
    
    @IBOutlet weak var userInformationLabel: UILabel!
    
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var phoneNumberView: UIView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var writeInformationButton: UIButton!
    
    var emailUid = ""

    var email = ""
    var name = ""
    var phoneNumber = ""
    var ref: DatabaseReference! = Database.database().reference()
    
    weak var messageDelegate: MessageDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameTextField.delegate = self
        self.emailTextField.delegate = self
        self.phoneNumberTextField.delegate = self
        self.configure()
        self.setData()
        print("viewdidload 실행")
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    
    @IBAction func tapdismissbutton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tabWriteInformationButton(_ sender: UIButton) {
        
        let name = nameTextField.text ?? " "
        let email = emailTextField.text ?? " "
        let phoneNumber = phoneNumberTextField.text ?? " "
        
        self.ref.child("\(emailUid)/userInformation/").updateChildValues(["name": name])
        self.ref.child("\(emailUid)/userInformation/").updateChildValues(["email": email])
        self.ref.child("\(emailUid)/userInformation/").updateChildValues(["phoneNumber": phoneNumber])
        
        self.messageDelegate?.messageDelegate()
        
        self.navigationController?.popViewController(animated: true)
        
    }
}


extension UserInformationViewController {
    
    private func configure() {
        self.configureUserInformationLabel()
        self.configureView()
        self.configureTextField()
        self.configureWriteButton()
    }
    
    private func configureUserInformationLabel() {
        self.userInformationLabel.font = UIFont(name: "NanumGothicOTFBold", size: 28)
    }
    
    private func configureTextField() {
        
        self.nameTextField.attributedPlaceholder = NSAttributedString(string: "이름을 입력해주세요 (선택사항)", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)]) // placeholder color
        
        self.emailTextField.attributedPlaceholder = NSAttributedString(string: "이메일을 입력해주세요 (선택사항)", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)]) // placeholder color
        
        self.phoneNumberTextField.attributedPlaceholder = NSAttributedString(string: "휴대폰 번호를 입력해주세요 (선택사항)", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)]) // placeholder color
    }
    
    private func configureView() {
        [nameView, emailView, phoneNumberView].forEach({
            $0.layer.addBorder([.bottom], color: UIColor.lightGray, width: 1.0)
        })
    }
    
    private func configureWriteButton() {
        self.writeInformationButton.layer.cornerRadius = 8
        self.writeInformationButton.titleLabel?.font = UIFont(name: "NanumGothicOTF", size: 15)
    }
    
    private func setData() {
        self.nameTextField.text = name
        self.emailTextField.text = email
        self.phoneNumberTextField.text = phoneNumber
    }
}

extension UserInformationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        
        // 최대 글자수 이상을 입력한 이후에는 중간에 다른 글자를 추가할 수 없게끔 작동
        if text.count >= 100 {
            return false
        }
        print(text.count)
        return true
    }
}
