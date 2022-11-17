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

/// loading 상태
enum LoadingState {
    case normal // normal
    case loading // 로딩중
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var dismissButton: UIButton!
    
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var appleLoginImageView: UIImageView!
    @IBOutlet weak var googleLoginImageView: UIImageView!
    @IBOutlet weak var kakaoLoginImageView: UIImageView!
    
    @IBOutlet weak var socialLoginStackView: UIStackView!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var iconClick = true
    var loadingState: LoadingState = .normal // 로딩 상태 (normal)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#fileID, #function, #line, "- ?")
        hideKeyboardWhenTappedAround() // 화면 클릭시 키보드 내림
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
        self.configureForgotPassword()
    }

    private func configureEmailTextField() {
        self.emailTextField.textFieldPlaceholder = "이메일을 입력해주세요"
    }
    
    private func configurePasswordTextField() {
        self.passwordTextField.textFieldPlaceholder = "비밀번호를 입력해주세요"
        self.passwordTextField.isSecureTextEntry = true
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

        self.hideViews()
        
        guard let email = self.emailTextField.text else { return }
        guard let password = self.passwordTextField.text else { return }

        UserDefaults.standard.set(email, forKey: "email")

        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if let error = error {
                let code = (error as NSError).code
                print(error, "에러")
                self.view.hideAllToasts()
                
                switch code {
                case 17008:
                    self.view.makeToast("이메일이 주소 형식이 아닙니다")
                case 17009:
                    self.view.makeToast("비밀번호가 틀렸습니다.")
                case 17011:
                    self.view.makeToast("등록되어 있지 않습니다.")
                case 17010:
                    self.view.makeToast("너무 많은 요청을 보냈습니다. 잠시 후에 다시 시도해주세요")
                default:
                    self.view.makeToast("\(error.localizedDescription)")
                }
                self.showViews()
            } else {
                print("login success")
                self.showViews()
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

        self.googleLoginImageView.addGestureRecognizer(tapGoogleLogo)
        self.appleLoginImageView.addGestureRecognizer(tapAppleLogo)
        self.kakaoLoginImageView.addGestureRecognizer(tapKakaoLogo)
        
    }
    
    @objc func tapGoogleImageSelector(sender: UITapGestureRecognizer) {
        self.hideViews()
        GIDSignIn.sharedInstance().signIn()
        self.showViews()
    }
    
    @objc func tapAppleImageSelector(sender: UITapGestureRecognizer) {
        print("tapAppleLogo")
    }
    
    @objc func tapKakaoImageSelector(sender: UITapGestureRecognizer) {
        print("tapKakaoLogo")
    }
}

// MARK: - indicator
extension LoginViewController {
    
    private func hideViews() {
        self.loadingState = .loading
        
        self.dismissButton.isUserInteractionEnabled = false
        self.emailTextField.isUserInteractionEnabled = false
        self.passwordTextField.isUserInteractionEnabled = false
        self.loginButton.isUserInteractionEnabled = false
        self.forgotPasswordButton.isUserInteractionEnabled = false
        self.googleLoginImageView.isUserInteractionEnabled = false
        self.appleLoginImageView.isUserInteractionEnabled = false
        self.kakaoLoginImageView.isUserInteractionEnabled = false

        activityIndicator.alpha = 1
        activityIndicator.startAnimating()
    }
    
    private func showViews() {
        
        UIView.animate(
            withDuration: 0.7,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .curveEaseOut,
            animations: {
                self.activityIndicator.alpha = 0

            }, completion: { _ in
                self.loadingState = .normal
                self.activityIndicator.stopAnimating()
                
                self.dismissButton.isUserInteractionEnabled = true
                self.emailTextField.isUserInteractionEnabled = true
                self.passwordTextField.isUserInteractionEnabled = true
                self.loginButton.isUserInteractionEnabled = true
                self.forgotPasswordButton.isSelected = true
                self.googleLoginImageView.isUserInteractionEnabled = true
                self.appleLoginImageView.isUserInteractionEnabled = true
                self.kakaoLoginImageView.isUserInteractionEnabled = true
            })
    }
}
