//
//  EnterEmailViewController.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/04/08.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        self.configure()
        
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        view.addGestureRecognizer(tapGesture)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        //navigatioin bar 보이기
        navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func tapBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        
        //Firebase 이메일/비밀번호 인증
        let email = self.emailTextField.text ?? ""
        let password = self.passwordTextField.text ?? ""
        
        //신규 사용자 생성
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                let code = (error as NSError).code
                print(error, "에러")
                switch code {
                case 17007: //이미 가입한 계정일때
                    //로그인하기
                    self.showToast(message: "이미 가입한 계정입니다.")
                    self.errorMessageLabel.text = error.localizedDescription
                    
                case 17008: // 이메일 주소형식이 아닐때
                    self.showToast(message: "이메일 주소 형식이 다릅니다.")
                    self.errorMessageLabel.text = error.localizedDescription
                default:
                    self.showToast(message: "\(error.localizedDescription)")
                    self.errorMessageLabel.text = error.localizedDescription
                }
            } else {
                self.showMainViewController()
            }
        }
    }
    
    private func loginUser(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] _, error in
            guard let self = self else { return }
            
            if let error = error {
                self.errorMessageLabel.text = error.localizedDescription
            } else {
                self.showMainViewController()
            }
        }
    }
    
    private func showMainViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mainTabbarViewController = storyboard.instantiateViewController(withIdentifier: "MainTabbar")
        mainTabbarViewController.modalPresentationStyle = .fullScreen
        navigationController?.show(mainTabbarViewController, sender: nil)
    }
}

extension SignUpViewController: UITextFieldDelegate {
    
    
    //이메일과 비밀번호가 입력한값이 다 있으면 다음 버튼 활성화
    func textFieldDidEndEditing(_ textField: UITextField) {
        let isEmailEmpty = self.emailTextField.text == ""
        let ispasswordEmpty = self.passwordTextField.text == ""
        print(isEmailEmpty, ispasswordEmpty)
        
        //isEnabled == true 면 버튼 활성화
        self.nextButton.isEnabled = !isEmailEmpty && !ispasswordEmpty
    }
}

extension SignUpViewController {
    
    private func configure() {
        self.configureNextButton()
        self.configureEmailTextField()
        self.configurePasswordTextField()
    }
    
    private func configureNextButton() {
        self.nextButton.layer.cornerRadius = 8
        self.nextButton.titleLabel?.font = UIFont(name: "NanumGothicOTF", size: 15)
    }
    
    private func configureEmailTextField() {
        self.emailTextField.textFieldPlaceholder = "이메일을 입력해주세요"
    }
    
    private func configurePasswordTextField() {
        self.passwordTextField.textFieldPlaceholder = "비밀번호를 입력해주세요."
    }
}
