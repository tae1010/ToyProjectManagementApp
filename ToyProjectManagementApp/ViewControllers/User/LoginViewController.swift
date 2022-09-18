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
    @IBOutlet weak var signInLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton: GIDSignInButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    
    @IBOutlet weak var logoImageView: LogoImageView!
    @IBOutlet weak var logoLabel: LogoLabel!
    @IBOutlet weak var logoStackView: UIStackView!
    
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Google Sign In
        GIDSignIn.sharedInstance().presentingViewController = self
        
        self.configure()
    }
    
    
    @IBAction func googleLoginButtonTapped(_ sender: UIButton) {
        //Firebase 인증
        GIDSignIn.sharedInstance().signIn()
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
    }
    
    private func configureLogoImageView() {
        self.logoImageView.layer.cornerRadius = 10
    }

    private func configureEmailTextField() {
        self.emailTextField.textFieldPlaceholder = "이메일을 입력해주세요"
    }
    
    private func configurePasswordTextField() {
        self.passwordTextField.textFieldPlaceholder = "비밀번호를 입력해주세요"
    }
    
    private func login(){
//
//        guard let email = self.emailTextFiled.text else { return }
//        guard let password = self.passwordTextField.text else { return }
//
//        UserDefaults.standard.set(email, forKey: "email")
//
//        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
//            if user != nil{
//                print("login success")
//                self.showMainViewController()
//            }
//            else {
//                print("login fail")
//
//            }
//        }
    }
    
    private func showMainViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mainTabbarViewController = storyboard.instantiateViewController(withIdentifier: "MainTabbar")
        mainTabbarViewController.modalPresentationStyle = .fullScreen
        navigationController?.show(mainTabbarViewController, sender: nil)
    }
}


