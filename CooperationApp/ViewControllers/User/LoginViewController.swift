//
//  LoginViewController.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/04/08.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {
    @IBOutlet weak var signInLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton: GIDSignInButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.configureNavigationView()
        self.configureBackGroundView()
        
        //Google Sign In
        GIDSignIn.sharedInstance().presentingViewController = self
        
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
    
    private func configureLoginButton() {
        
    }
}
