
//
//  MainTabbarViewController.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/04/07.
//

import Foundation
import UIKit
import FirebaseDatabase
import Firebase
import FirebaseAuth
import Toast_Swift

class ForthTabbarViewController: UIViewController {

    @IBOutlet weak var myPageTitleLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var userInformationImageView: UIImageView!
    
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
    
    var email = ""
    var name = ""
    var phoneNumber = ""
    
    var ref: DatabaseReference! = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //pop제스처를 막아줌
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.configure()
        
        // user information 창 이동
        let tapUserInformation = UITapGestureRecognizer(target: self, action: #selector(tabUserInformationImageView))

        self.userInformationImageView.addGestureRecognizer(tapUserInformation)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#fileID, #function, #line, "forth tabbar viewwillappear")
        
        //네비게이션바를 숨김
        navigationController?.navigationBar.isHidden = true
        
        self.hiddenChangePasswordView()
        self.readDB()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#fileID, #function, #line, "forth tabbar viewDidAppear")
        
        self.inPrograssCountLabel.text = "\(SharedData.inProgressProjectCount)"
        self.completeCountLabel.text = "\(SharedData.completeProjectCount)"
        self.totalProjectCountLabel.text = "\(SharedData.totalProjectCount)"
    }

    // sign out popup 뷰로 이동
    @IBAction func logoutButtonTapped(_ sender: UIButton) {

        let signOutPopup = SignOutPopupViewController(nibName: "SignOutPopup", bundle: nil)
        signOutPopup.logoutDelegate = self
        
        signOutPopup.modalPresentationStyle = .overCurrentContext
        signOutPopup.modalTransitionStyle = .crossDissolve // 뷰가 투명해지면서 넘어가는 애니메이션
        self.present(signOutPopup, animated: false, completion: nil)

    }
    
    @IBAction func resetPasswordButtonTap(_ sender: UIButton) {
        let email = String(FirebaseAuth.Auth.auth().currentUser?.uid ?? "applelogin")
        
        Auth.auth().sendPasswordReset(withEmail: email, completion: nil)
        
        self.view.hideAllToasts()
        self.view.makeToast("로그인한 메일에 비밀번호 재설정 메일을 보내드렸습니다")
    }
    
    @objc func tabUserInformationImageView() {
        let userInformationStoryBoard = UIStoryboard(name: "UserInformation", bundle: nil)
        guard let userInformationVC = userInformationStoryBoard.instantiateViewController(identifier: "UserInformation") as? UserInformationViewController else { return }
        
        userInformationVC.name = self.name
        userInformationVC.email = self.email
        userInformationVC.phoneNumber = self.phoneNumber
        
        userInformationVC.messageDelegate = self
        
        navigationController?.pushViewController(userInformationVC, animated: true)
    }
    
    //db값을 읽어서 projectList에 db값을 넣어준 뒤 collectionview 업데이트 해주는 함수
    private func readDB() {
        
        let emailUid = String(FirebaseAuth.Auth.auth().currentUser?.uid ?? "applelogin")
        self.setDate()
        ref.child("\(emailUid)/userInformation").observeSingleEvent(of: .value, with: { [self] snapshot in
            // Get user value
            guard let value = snapshot.value as? Dictionary<String, String> else { return }

            let name = value["name"] ?? ""
            let email = value["email"] ?? ""
            let phoneNumber = value["phoenNumber"] ?? ""
            
            print(name, email)
            self.name = name
            self.email = email
            self.phoneNumber = phoneNumber
            
            self.setDate()
            
        }) { error in
            print(error.localizedDescription)
        }
    }
    
    private func hiddenChangePasswordView() {
        let isEmailSignin = Auth.auth().currentUser?.providerData[0].providerID == "password"

        self.resetPasswordView.isHidden = !isEmailSignin
    }

}

// MARK: - configure
extension ForthTabbarViewController {
    
    private func configure() {
        self.configureMyPageTitleLabel()
        self.configureEmailLabel()
        self.configureNameLabel()
        self.configureActivityLabel()
        self.configureCountLabel()
        self.configureUserButton()
    }
    
    private func configureMyPageTitleLabel() {
        self.myPageTitleLabel.font = UIFont(name: "NanumGothicOTFBold", size: 20)

    }
    
    private func configureEmailLabel() {
        let emailUid = String(FirebaseAuth.Auth.auth().currentUser?.uid ?? "applelogin")
        
        self.emailLabel.font = UIFont(name: "NanumGothicOTFBold", size: 16)
    }
    
    private func configureNameLabel() {
        self.nameLabel.font = UIFont(name: "NanumGothicOTFLight", size: 13)
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
    
    private func setDate() {
        self.emailLabel.text = email
        self.nameLabel.text = self.name == "" ? "" : "@\(name)"
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

extension ForthTabbarViewController: MessageDelegate {
    
    func messageDelegate() {
        self.view.hideAllToasts()
        self.view.makeToast("작성되었습니다",duration: 1)
    }
  
}
