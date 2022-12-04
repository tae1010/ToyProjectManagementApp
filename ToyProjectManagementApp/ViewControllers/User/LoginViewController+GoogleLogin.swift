//
//  LoginViewController+GoogleLogin.swift
//  ToyProjectManagementApp
//
//  Created by 김정태 on 2022/11/28.
//

import UIKit
import GoogleSignIn
import Firebase
import FirebaseAuth
import AuthenticationServices // 사용자가 앱 및 서비스에 쉽게 로그인하게 하는 애플의 프레임워크
import CryptoKit // 암호화 작업을 안전하고 효율적으로 수행하는 애플의 프레임워크
import MaterialComponents.MaterialBottomSheet
import Toast_Swift

extension LoginViewController: GIDSignInDelegate {

    // Google 로그인 인증 후 전달된 값 처리하기
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("ERROR GOOGLE SIGN IN \(error.localizedDescription)")
            self.showViews()
            return
        }

        // 사용자 인증값 가져오기
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        print(type(of: credential))
        print(credential,"카카")
        print(FirebaseApp.app()?.options.clientID, "카카")
        
        UserDefault().setLoginDataUserDefault(checkLogin: CheckLogin(lastLogin: .google))
        
        Auth.auth().signIn(with: credential) { _, _ in
            print("signin 성공")
            self.showMainViewController()
        }

    }
    
    
}
