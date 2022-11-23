//
//  KakaoAuthVM.swift
//  ToyProjectManagementApp
//
//  Created by 김정태 on 2022/11/23.
//

import Foundation
import Combine
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import FirebaseAuth
import Firebase

class KakaoAuthVM: ObservableObject {
    
    var subscriptions = Set<AnyCancellable>()
    
    var emailUid = ""
    var kakaoUserId = ""
    
    init() {
        print("KakaoAuthVM - handleKakaoLogin() called ")
    }
    
    // 카카오톡으로 로그인
    func loginWithKakaotalk() {
        
        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            if let error = error {
                print("kakaotak login 애러")
                print(error)
            }
            
            else {
                print("loginWithKakaoTalk() success.")

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
                print("kakaotak account 애러")
                print(error)
            }
            else {
                print("loginWithKakaoAccount() success.")
                

                self.showMainViewController()
                //do something
                _ = oauthToken
            }
        }
    }
    
    // 카카오 로그인
    func loginKakao() {
        UserApi.shared.accessTokenInfo { _, error in
            if let error = error {
                print("_________login error_________")
                print(error)
            } else {
                print("access Token")
            }
            
            // 카카오톡 설치 여부 확인
            if UserApi.isKakaoTalkLoginAvailable() {
                self.loginWithKakaotalk()
                
                // 카카오톡 설치 x
            } else {
                self.loginWithKakaoAccount()
            }
            
        }
    }
    
    // 카카오 로그인 + 토큰 여부 확인
    func handleKakaoLogin() {
        self.loginKakao()
    }
    
    // 카카오 로그아웃
    func kakaoLogout() {
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("logout() success.")
            }
        }
    }

    
    private func showMainViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainTabbar")
        
        mainViewController.modalPresentationStyle = .fullScreen

        UIApplication.shared.windows.first?.rootViewController?.show(mainViewController, sender: nil)
 
    }

}
