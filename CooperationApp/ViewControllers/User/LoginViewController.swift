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
        
        //Navigation bar 숨기기
        navigationController?.navigationBar.isHidden = true
        
        //Google Sign In
        GIDSignIn.sharedInstance().presentingViewController = self
        
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [signInLoginButton, googleLoginButton, appleLoginButton].forEach {
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.black.cgColor
            $0?.layer.cornerRadius = 30
        }
    }
    
    
    @IBAction func googleLoginButtonTapped(_ sender: UIButton) {
        //Firebase 인증
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func appleLogingButtonTapped(_ sender: UIButton) {
        //Firebase 인증
    }
    
    
}
