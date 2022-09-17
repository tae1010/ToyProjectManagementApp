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
    @IBOutlet weak var logoTitleLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    
    let logoStackView = LogoStackView()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Google Sign In
        GIDSignIn.sharedInstance().presentingViewController = self
        
        self.configureNavigationView()
        self.configureBackGroundView()
        self.configureLogoTitleLabel()
        self.configureLogoImageView()
        configureStackView()
    }
    
    
    @IBAction func googleLoginButtonTapped(_ sender: UIButton) {
        //Firebase 인증
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func appleLogingButtonTapped(_ sender: UIButton) {
        //Firebase 인증
    }
    
    
}

extension LoginViewController {
    
    // configure navigationBar View
    private func configureNavigationView() {
        //Navigation bar 숨기기
        navigationController?.navigationBar.isHidden = true
    }
    
    // configure backgroud View
    private func configureBackGroundView() {
//        self.view.backgroundColor = .primaryColor
    }
    
    private func configureStackView() {
        logoStackView.translatesAutoresizingMaskIntoConstraints = false
        
        logoStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        logoStackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor
        ).isActive = true
    }
    
    private func configureLoginButton() {
        
    }
    
    private func configureLogoImageView() {
        self.logoImageView.layer.cornerRadius = 10
    }
    
    private func configureLogoTitleLabel() {
        self.logoTitleLabel.font = UIFont(name: "glogo", size: 40)
        self.logoTitleLabel.text = "Toy"
        self.logoTitleLabel.textColor = .primaryColor
        
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
