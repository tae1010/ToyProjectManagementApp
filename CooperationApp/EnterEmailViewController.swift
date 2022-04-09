//
//  EnterEmailViewController.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/04/08.
//

import UIKit
import FirebaseAuth

class EnterEmailViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nextButton.layer.cornerRadius = 30
        self.nextButton.isEnabled = false
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        //화면을 켯을때 커서가 emailtextField에 위치할수 있도록 해줌
        emailTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //navigatioin bar 보이기
        navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        //Firebase 이메일/비밀번호 인증
        let email = self.emailTextField.text ?? ""
        let password = self.passwordTextField.text ?? ""
        
        //신규 사용자 생성
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            
        }
    }
    
    private func showMainViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mainTabbarViewController = storyboard.instantiateViewController(withIdentifier: "MainTabberViewController")
        mainTabbarViewController.modalPresentationStyle = .fullScreen
        navigationController?.show(mainTabbarViewController, sender: nil)
    }
}

extension EnterEmailViewController: UITextFieldDelegate {
    
    //이메일 비밀번호 입력이 끝나고 리턴버튼이 눌리면 키보드가 내려가는 메서드
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    //이메일과 비밀번호가 입력한값이 다 있으면 다음 버튼 활성화
    func textFieldDidEndEditing(_ textField: UITextField) {
        let isEmailEmpty = self.emailTextField.text == ""
        let ispasswordEmpty = self.passwordTextField.text == ""
        
        self.nextButton.isEnabled = !isEmailEmpty && !ispasswordEmpty
    }
}
