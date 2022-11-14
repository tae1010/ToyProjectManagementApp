//
//  EnterEmailViewController.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/04/08.
//

import UIKit
import FirebaseAuth
import Toast_Swift

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround() // 화면 클릭시 키보드 내림
        
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
        self.hideViews()
        
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
                    self.view.makeToast("이미 가입한 계정입니다.")
                    
                case 17008: // 이메일 주소형식이 아닐때
                    self.view.makeToast("이메일 주소 형식이 다릅니다.")
                    
                case 17026: // 비밀번호 6자리 이하일때
                    self.view.makeToast("비밀번호는 6자리 이상이어야 됩니다.")
                    
                case 17034: // 이메일 주소가 빈칸일때
                    self.view.makeToast("이메일 주소를 적어주십시오.")
                default:
                    self.view.makeToast("\(error.localizedDescription) 에러")
                }
                
                self.showViews()
            } else {
                self.showViews()
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


// MARK: - indicator
extension SignUpViewController {
    
    private func hideViews() {
        
        self.emailTextField.isUserInteractionEnabled = false
        self.passwordTextField.isUserInteractionEnabled = false
        self.nextButton.isUserInteractionEnabled = false
        
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
                self.activityIndicator.stopAnimating()
                
                self.emailTextField.isUserInteractionEnabled = true
                self.passwordTextField.isUserInteractionEnabled = true
                self.nextButton.isUserInteractionEnabled = true
                
            })
    }
}
