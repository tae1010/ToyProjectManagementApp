//
//  SignInViewController.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/04/13.
//

import UIKit
import Firebase
import FirebaseAuth

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextFiled: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let userDefaults = UserDefaults.standard

    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let emailData = userDefaults.object(forKey: "email") else { return }
        
        emailTextFiled.text = emailData as? String

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //navigatioin bar 보이기
        navigationController?.navigationBar.isHidden = false
    }
    
    
    @IBAction func signInButtonTap(_ sender: UIButton) {
        self.login()
    }
    
    private func login(){
        
        guard let email = self.emailTextFiled.text else { return }
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
}
