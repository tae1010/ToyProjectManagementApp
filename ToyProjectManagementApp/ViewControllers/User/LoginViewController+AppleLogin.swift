//
//  LoginViewController+AppleLogin.swift
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

// MARK: - 애플 인증 관련 콜백 프로토콜
extension LoginViewController: ASAuthorizationControllerDelegate {
    
    // 인증이 실패할때 (창닫을때)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.showViews()
    }
    
    // 인증이 성공할떄
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // 몇 가지 표준 키 검사를 수행

            // 현재 nonce가 설정되어 있는지 확인
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            
            // ID 토큰을 검색
            guard let appleIDtoken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            
            
            
            // 검색한 ID 토큰을 문자열로 변환
            guard let idTokenString = String(data: appleIDtoken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDtoken.debugDescription)")
                return
            }
            
            
            // nonce와 ID 토큰을 사용해 OAuthProvider에게 방금 로그인한 사용자를 나타내는 credential을 생성하도록 요청
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            
            // credential을 사용하여 Firebase에 로그인
            Auth.auth().signIn(with: credential) { (authDataResult, error) in
                // 인증 결과에서 Firebase 사용자를 검색하고 사용자 정보를 표시할 수 있다.

                
                if error != nil {
                    print(error?.localizedDescription ?? "error" as Any)
                    self.showViews()
                    return
                }
                
                self.showViews()
                print("성공?")
                self.showMainViewController()
            }
            
        }
        
    }
    

    @available(iOS 13, *)
    func createAppleIDRequest() -> ASAuthorizationAppleIDRequest {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        // 애플로그인은 사용자에게서 2가지 정보를 요구함
        request.requestedScopes = [.fullName, .email]
        print(request.requestedScopes = [.fullName, .email])
        let nonce = randomNonceString()
        request.nonce = sha256(nonce)
        currentNonce = nonce
        
        return request
    }
    
    // 해시 알고리즘
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }

    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    
}

// MARK: - 프레젠테이션 컨텍스트 프로토콜
extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
