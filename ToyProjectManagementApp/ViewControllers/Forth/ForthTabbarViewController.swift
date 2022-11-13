
//
//  MainTabbarViewController.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/04/07.
//

import UIKit
import Toast_Swift
import FirebaseAuth

class ForthTabbarViewController: UIViewController {

    @IBOutlet weak var myPageTitleLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var activityLabel: UILabel!
    
    @IBOutlet weak var totalProjectCountLabel: UILabel!
    @IBOutlet weak var completeCountLabel: UILabel!
    @IBOutlet weak var inPrograssCountLabel: UILabel!

    @IBOutlet weak var totalProjectLabel: UILabel!
    @IBOutlet weak var inPrograssLabel: UILabel!
    @IBOutlet weak var completeLabel: UILabel!
    
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var resetPasswordButton: UIButton!

    @IBOutlet weak var resetPasswordView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //pop제스처를 막아줌
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        self.configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //네비게이션바를 숨김
        navigationController?.navigationBar.isHidden = true
        
        //email에 유저 email값을 넣고 만약에 값이 없다면 고객이라는 값을 넣는다
        let email = Auth.auth().currentUser?.email ?? "고객"
        
        let isEmailSignin = Auth.auth().currentUser?.providerData[0].providerID == "password"
        self.resetPasswordView.isHidden = !isEmailSignin
        
        NotificationCenter.default.addObserver(self, selector: #selector(projectCountNotification), name: .projectCountNotification, object: nil)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .projectCountNotification, object: nil)
    }

    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        
//        let signOutPopup = SignOutPopupViewController(nibName: "SignOutPopup", bundle: nil)
//
//        signOutPopup.modalPresentationStyle = .overCurrentContext
//        signOutPopup.modalTransitionStyle = .crossDissolve
//        
//        navigationController?.pushViewController(signOutPopup, animated: false)
        
        let signOutPopup = SignOutPopupViewController(nibName: "SignOutPopup", bundle: nil)
        signOutPopup.logoutDelegate = self
        
        signOutPopup.modalPresentationStyle = .overCurrentContext
        signOutPopup.modalTransitionStyle = .crossDissolve // 뷰가 투명해지면서 넘어가는 애니메이션
        self.present(signOutPopup, animated: false, completion: nil)
        

        
    }
    
    @IBAction func resetPasswordButtonTap(_ sender: UIButton) {
        let email = Auth.auth().currentUser?.email ?? ""
        Auth.auth().sendPasswordReset(withEmail: email, completion: nil)
        
        self.view.hideToast()
        self.view.makeToast("로그인한 메일에 비밀번호 재설정 링크를 보내드렸습니다")
    }
}

extension ForthTabbarViewController {
    
    private func configure() {
        self.configureMyPageTitleLabel()
        self.configureEmailLabel()
        self.configureActivityLabel()
        self.configureCountLabel()
        self.configureUserButton()
    }
    
    private func configureMyPageTitleLabel() {
        self.myPageTitleLabel.font = UIFont(name: "NanumGothicOTFBold", size: 20)

    }
    
    private func configureEmailLabel() {
        let email = Auth.auth().currentUser?.email ?? ""
        self.emailLabel.font = UIFont(name: "NanumGothicOTFBold", size: 16)
        self.emailLabel.text = email
    }
    
    private func configureActivityLabel() {
        self.activityLabel.font = UIFont(name: "NanumGothicOTFBold", size: 16)
    }
    
    private func configureCountLabel() {
        [totalProjectCountLabel, completeCountLabel, inPrograssCountLabel].forEach({
            $0?.font = UIFont(name: "NanumGothicOTF", size: 16)
        })
        
        [totalProjectLabel, inPrograssLabel, completeLabel].forEach({
            $0?.font = UIFont(name: "NanumGothicOTF", size: 12)
        })
    }
    
    private func configureUserButton() {
        [signOutButton, resetPasswordButton].forEach({
            $0?.titleLabel?.font = UIFont(name: "NanumGothicOTF", size: 14)
        })
    }

}

// MARK: - notification
extension ForthTabbarViewController {
    
    @objc func projectCountNotification(_ notification: Notification) {
    
        let getValue = notification.object as! [Int] // [총 프로젝트수, 진행중, 완료]
        self.totalProjectCountLabel.text = String(getValue[0])
        self.inPrograssCountLabel.text = String(getValue[1])
        self.completeCountLabel.text = String(getValue[2])
    }
    
}

extension ForthTabbarViewController: LogoutDelegate {
    
    func logoutDelegate() {
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
            self.navigationController?.popToRootViewController(animated: true)
            
        } catch let sighOutError as NSError {
            print("Error signout \(sighOutError.localizedDescription)")
        }
    }
    
    
}