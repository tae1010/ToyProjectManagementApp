//
//  LoginViewController.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/04/08.
//

import UIKit
import GoogleSignIn
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var appleLoginImageView: UIImageView!
    @IBOutlet weak var googleLoginImageView: UIImageView!
    @IBOutlet weak var kakaoLoginImageView: UIImageView!
    
    @IBOutlet weak var socialLoginStackView: UIStackView!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    var iconClick = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Google Sign In
        GIDSignIn.sharedInstance().presentingViewController = self
        
        // configure view
        self.configure()
        
        // tap socialLogin
        self.tabSocialLoginImageView()
    }
    
    
    @IBAction func tapBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        self.login()
    }
    
 
}

// MARK: - view configure
extension LoginViewController {
    
    private func configure() {
        self.configureEmailTextField()
        self.configurePasswordTextField()
        self.configurelLoginButton()
    }

    private func configureEmailTextField() {
        self.emailTextField.textFieldPlaceholder = "이메일을 입력해주세요"
    }
    
    private func configurePasswordTextField() {
        self.passwordTextField.textFieldPlaceholder = "비밀번호를 입력해주세요"
        self.passwordTextField.isSecureTextEntry = true
    }
    
    @objc func buttonAction(sender: UIButton!) {
        
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 15, height: passwordTextField.frame.height))
        print("icon 클릭 \(iconClick)")
        
        if iconClick {
            rightButton.setImage(UIImage(systemName: "eye"), for: .normal)
            self.passwordTextField.rightView = rightButton
            passwordTextField.isSecureTextEntry = false
        } else {
            rightButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
            self.passwordTextField.rightView = rightButton
            passwordTextField.isSecureTextEntry = true
        }
        
        iconClick.toggle()
    }
    
    private func configurelLoginButton() {
        self.loginButton.layer.cornerRadius = 8
        self.loginButton.titleLabel?.font = UIFont(name: "NanumGothicOTF", size: 15)
    }
    
    
    private func configureForgotPassword() {
        self.forgotPasswordButton.titleLabel?.font = UIFont(name: "NanumGothicOTF", size: 13)
    }
    
}

// MARK: - 기능 관련 함수
extension LoginViewController {
    
    private func login(){

        guard let email = self.emailTextField.text else { return }
        guard let password = self.passwordTextField.text else { return }

        UserDefaults.standard.set(email, forKey: "email")

        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if let error = error {
                let code = (error as NSError).code
                print(error, "에러")
                switch code {
                case 17008:
                    self.view.makeToast("이메일이 주소 형식이 아닙니다")
                case 17009:
                    self.view.makeToast("비밀번호가 틀렸습니다.")
                case 17011:
                    self.view.makeToast("등록되어 있지 않습니다.")
                default:
                    self.view.makeToast("\(error.localizedDescription)")
                }
            } else {
                print("login success")
                self.showMainViewController()

            }
        }
    }
    
    private func showMainViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mainTabbarViewController = storyboard.instantiateViewController(withIdentifier: "MainTabbar")
        mainTabbarViewController.modalPresentationStyle = .fullScreen
        mainTabbarViewController.modalTransitionStyle = .crossDissolve
        
        navigationController?.show(mainTabbarViewController, sender: nil)
    }
    
    private func tabSocialLoginImageView() {
        
        let tapGoogleLogo = UITapGestureRecognizer(target: self, action: #selector(tapGoogleImageSelector))
        let tapAppleLogo = UITapGestureRecognizer(target: self, action: #selector(tapAppleImageSelector))
        let tapKakaoLogo = UITapGestureRecognizer(target: self, action: #selector(tapKakaoImageSelector))
        
        self.googleLoginImageView.isUserInteractionEnabled = true
        self.appleLoginImageView.isUserInteractionEnabled = true
        self.kakaoLoginImageView.isUserInteractionEnabled = true
        
        self.googleLoginImageView.addGestureRecognizer(tapGoogleLogo)
        self.appleLoginImageView.addGestureRecognizer(tapAppleLogo)
        self.kakaoLoginImageView.addGestureRecognizer(tapKakaoLogo)
    }
    
    @objc func tapGoogleImageSelector(sender: UITapGestureRecognizer) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @objc func tapAppleImageSelector(sender: UITapGestureRecognizer) {
        print("tapAppleLogo")
    }
    
    @objc func tapKakaoImageSelector(sender: UITapGestureRecognizer) {
        print("tapKakaoLogo")
    }
}
