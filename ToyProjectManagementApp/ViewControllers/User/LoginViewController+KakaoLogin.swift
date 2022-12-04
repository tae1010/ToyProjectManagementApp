//
//  LoginViewController+KakaoLogin.swift
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

import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import WebKit


// MARK: - 카카오 인증 관련
extension LoginViewController {
    
    // 카카오톡으로 로그인
    func loginWithKakaotalk() {
        
        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            if let error = error {
                self.showViews()
                print("kakaotak login 애러")
                print(error)
            }
            
            else {
                print("loginWithKakaoTalk() success.")
                UserDefault().setLoginDataUserDefault(checkLogin: CheckLogin(lastLogin: .kakao))
                self.showViews()
                self.showMainViewController()
                //do something
                _ = oauthToken
            }
        }
    }
    
    // 카카오계정으로 로그인
    func loginWithKakaoAccount() {
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                self.showViews()
                print("kakaotak account 애러")
                print(error)
            }
            else {
                print("loginWithKakaoAccount() success.")
                print(type(of: oauthToken))
                print(oauthToken, "카카오로그인 credential")
                UserDefault().setLoginDataUserDefault(checkLogin: CheckLogin(lastLogin: .kakao))
                
                
                self.showViews()
                self.showMainViewController()
                //do something
                _ = oauthToken
            }
        }
    }
    
    // 카카오 로그인
    func loginKakao() {
        // 카카오톡 설치 여부 확인
        if UserApi.isKakaoTalkLoginAvailable() {
//            self.checkKakaoToken()
            self.loginWithKakaotalk()
            
        // 카카오톡 설치 x
        } else {
//            self.checkKakaoToken()
            self.loginWithKakaoAccount()
        }
    }
    
//    func checkKakaoToken() {
//
//        if (AuthApi.hasToken()) {
//
//            print("일단 카카오 토큰은 있음")
//            UserApi.shared.accessTokenInfo {(accessTokenInfo, error) in
//                if let error = error {
//                    print("토큰 access 에러")
//                    print(error)
//                }
//                else {
//
//                    print("accessTokenInfo() success.")
//                    UserDefault().setLoginDataUserDefault(checkLogin: CheckLogin(token: "\(String(describing: accessTokenInfo?.id))", lastLogin: .kakao))
//                    //do something
//                    print(accessTokenInfo, "이거랑??")
//                }
//            }
//        }
//        else {
//            print("카카오 토큰이 없음")
//            //로그인 필요
//        }
//
//
//    }
//
}
