//
//  MainTabbarViewController.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/04/07.
//

import UIKit
import FirebaseAuth

class MainTabbarViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //pop제스처를 막아줌
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //네비게이션바를 숨김
        navigationController?.navigationBar.isHidden = true
        
        //email에 유저 email값을 넣고 만약에 값이 없다면 고객이라는 값을 넣는다
        let email = Auth.auth().currentUser?.email ?? "고객"
        self.welcomeLabel.text = """
        환영합니다.
        \(email)님
        """
        
    }

    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        //로그아웃후 처음 로그인 화면으로 돌아가기
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
            self.navigationController?.popToRootViewController(animated: true)
        } catch let sighOutError as NSError {
            print("Error signout \(sighOutError.localizedDescription)")
        }
        
       
    }
    
}
