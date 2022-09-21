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
    
    @IBOutlet weak var logoImageView: LogoImageView!
    @IBOutlet weak var logoLabel: LogoLabel!
    @IBOutlet weak var logoStackView: UIStackView!
    
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var appleLoginImageView: UIImageView!
    @IBOutlet weak var googleLoginImageView: UIImageView!
    @IBOutlet weak var kakaoLoginImageView: UIImageView!
    
    @IBOutlet weak var socialLoginStackView: UIStackView!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
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
    
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        self.login()
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        let vc = SignUpViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func googleLoginButtonTapped(_ sender: UIButton) {
        //Firebase 인증
        
    }
    
    @IBAction func appleLogingButtonTapped(_ sender: UIButton) {
        //Firebase 인증
    }
    
 
}

// MARK: - view configure
extension LoginViewController {
    
    private func configure() {
        self.configureLogoImageView()
        self.configureEmailTextField()
        self.configurePasswordTextField()
        self.configurelLoginButton()
        self.configureSignUpButton()
    }
    
    private func configureLogoImageView() {
        self.logoImageView.layer.cornerRadius = 10
    }

    private func configureEmailTextField() {
        self.emailTextField.textFieldPlaceholder = "이메일을 입력해주세요"
    }
    
    private func configurePasswordTextField() {
        self.passwordTextField.textFieldPlaceholder = "비밀번호를 입력해주세요"
        self.passwordTextField.isSecureTextEntry = true
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 15, height: passwordTextField.frame.height))
        rightButton.setImage(UIImage(systemName: "eye"), for: .normal)
        rightButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        self.passwordTextField.rightView = rightButton
        passwordTextField.rightViewMode = .always
    }
    
    @objc func buttonAction(sender: UIButton!) {
        sender.setImage(UIImage(systemName: "eye.fill"), for: .normal)
    }
    
    private func configurelLoginButton() {
        self.loginButton.layer.cornerRadius = 8
        self.loginButton.titleLabel?.font = UIFont(name: "NanumGothicOTF", size: 15)
    }
    
    private func configureSignUpButton() {
        self.signUpButton.layer.cornerRadius = 8
        self.signUpButton.titleLabel?.font = UIFont(name: "NanumGothicOTF", size: 15)
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
            if user != nil{
                print("login success")
                self.showMainViewController()
            }
            else {
                print("login fail")

            }
        }
    }
    
    private func showMainViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mainTabbarViewController = storyboard.instantiateViewController(withIdentifier: "MainTabbar")
        mainTabbarViewController.modalPresentationStyle = .fullScreen
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
