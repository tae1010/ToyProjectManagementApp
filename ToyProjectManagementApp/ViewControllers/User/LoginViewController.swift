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
import AuthenticationServices // 사용자가 앱 및 서비스에 쉽게 로그인하게 하는 애플의 프레임워크
import CryptoKit // 암호화 작업을 안전하고 효율적으로 수행하는 애플의 프레임워크

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
    
    @IBOutlet weak var snsLoginLabel: UILabel!
    
    @IBOutlet weak var appleLoginImageView: UIImageView!
    @IBOutlet weak var googleLoginImageView: UIImageView!
    @IBOutlet weak var kakaoLoginImageView: UIImageView!
    
    @IBOutlet weak var socialLoginStackView: UIStackView!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    lazy var kakaoAuthVM: KakaoAuthVM = { KakaoAuthVM() }()
    
    var iconClick = true
    var loadingState: LoadingState = .normal // 로딩 상태 (normal)
    
    fileprivate var currentNonce: String?
    
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
    
 
    @IBAction func tabForgotPasswordButton(_ sender: UIButton) {
        print("tabtabForgotPasswordButton")
    }
}

// MARK: - view configure
extension LoginViewController {
    
    private func configure() {
        self.configureEmailTextField()
        self.configurePasswordTextField()
        self.configurelLoginButton()
        self.configureSNSLoginButton()
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
    
    private func configureSNSLoginButton() {
        self.snsLoginLabel.font = UIFont(name: "NanumGothicOTF", size: 13)
    }
    
    private func configureForgotPassword() {
        self.forgotPasswordButton.titleLabel?.font = UIFont(name: "NanumGothicOTF", size: 13)
    }
    
}

// MARK: - 기능 관련 함수
extension LoginViewController {
    
    // 기본 로그인
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
                
                self.showMainViewController()
                
            }
        }
    }
    
    // mainViewController 이동
    private func showMainViewController() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mainTabbarViewController = storyboard.instantiateViewController(withIdentifier: "MainTabbar")
        mainTabbarViewController.modalPresentationStyle = .fullScreen
        mainTabbarViewController.modalTransitionStyle = .crossDissolve
        self.showViews()
        navigationController?.show(mainTabbarViewController, sender: nil)
    }
    
    
    // 소셜로그인 selector
    private func tabSocialLoginImageView() {
        
        let tapGoogleLogo = UITapGestureRecognizer(target: self, action: #selector(tapGoogleImageSelector))
        let tapAppleLogo = UITapGestureRecognizer(target: self, action: #selector(tapAppleImageSelector))
        let tapKakaoLogo = UITapGestureRecognizer(target: self, action: #selector(tapKakaoImageSelector))

        self.googleLoginImageView.addGestureRecognizer(tapGoogleLogo)
        self.appleLoginImageView.addGestureRecognizer(tapAppleLogo)
        self.kakaoLoginImageView.addGestureRecognizer(tapKakaoLogo)
        
    }
    
    // tab google login
    @objc func tapGoogleImageSelector(sender: UITapGestureRecognizer) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    // tab apple login
    @objc func tapAppleImageSelector(sender: UITapGestureRecognizer) {
        print("tapAppleLogo")
        // 로그인 프로세스를 시작하는 메소드
        let request = createAppleIDRequest() // Apple ID를 기반으로 사용자를 인증하는 요청을 생성하는 메커니즘
        let authorizationController = ASAuthorizationController(authorizationRequests: [request]) // 권한 부여 요청을 관리하는 컨트롤러
        
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    // tab kakao login
    @objc func tapKakaoImageSelector(sender: UITapGestureRecognizer) {
        print("tapKakaoLogo")
        kakaoAuthVM.handleKakaoLogin()
        
    }
    
    
}

// MARK: - configure indicator
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




// MARK: - 프레젠테이션 컨텍스트 프로토콜
extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

// Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
private func randomNonceString(length: Int = 32) -> String {
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




// MARK: - 애플 인증 관련 콜백 프로토콜
extension LoginViewController: ASAuthorizationControllerDelegate {
    
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
            FirebaseAuth.Auth.auth().signIn(with: credential) { (authDataResult, error) in
                // 인증 결과에서 Firebase 사용자를 검색하고 사용자 정보를 표시할 수 있다.
                
                /// 2번째 애플 로그인부터는 email이 identityToken에 들어있음.
                if authDataResult?.user.email == nil {
                    print(self.decode(jwtToken: idTokenString)["email"] as? String ?? "","이게 변환이 잘됨?")
                }
                print(idTokenString)
                if let user = authDataResult?.user {
                    print("애플 로그인 성공!")
                    print(user.uid, "//")
                    print(user.email, "//")
                    print(user.phoneNumber)
                    self.showViews()
                    self.showMainViewController()
                }
                
                if error != nil {
                    print("여기서 에러")
                    print(error?.localizedDescription ?? "error" as Any)
                    self.showViews()
                    return
                }
            }
        }
        
    }
    
    /// JWTToken -> dictionary
    func decode(jwtToken jwt: String) -> [String: Any] {
        let segments = jwt.components(separatedBy: ".")
        return decodeJWTPart(segments[1]) ?? [:]
    }
    
    func base64UrlDecode(_ value: String) -> Data? {
        var base64 = value
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
        let requiredLength = 4 * ceil(length / 4.0)
        let paddingLength = requiredLength - length
        if paddingLength > 0 {
            let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
            base64 = base64 + padding
        }
        return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
    }
    
    func decodeJWTPart(_ value: String) -> [String: Any]? {
        guard let bodyData = base64UrlDecode(value),
              let json = try? JSONSerialization.jsonObject(with: bodyData, options: []), let payload = json as? [String: Any] else {
            return nil
        }
        
        return payload
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

}
