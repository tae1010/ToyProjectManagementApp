//
//  AppDelegate.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/04/04.
//

import Firebase
import UIKit
import FirebaseCore
import GoogleSignIn
import FirebaseAuth
import CoreData
import FirebaseDatabase
import AuthenticationServices
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import Network
import CryptoKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, ASAuthorizationControllerDelegate {
    
    var currentNonce: String?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 네트워크 감지
        startMonitoring()
        
        //Firebase초기화
        FirebaseApp.configure()
        
        let nativeAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? "" // config에 저장한 값
        KakaoSDK.initSDK(appKey: nativeAppKey as! String)
        
        checkLoginInfo()
        
        return true
    }
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        // 카카오톡 url 수신
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            print("카카오 url 수신")
            return AuthController.handleOpenUrl(url: url)
        
        // //구글에 인증프로세스가 끝날때 앱이 수신하는 url을 처리하는 역할
        } else if GIDSignIn.sharedInstance().handle(url) {
            print("구글 url 수신")
            return true
        }
        
        return false
    }

    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
        // 세로방향 고정
        return UIInterfaceOrientationMask.portrait
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "ToyProjectManagementApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

extension AppDelegate {
    
    // 네트워크 실시간 감지
    func startMonitoring() {
        
        let monitor = NWPathMonitor()
        
        let alert = UIAlertController(title: "인터넷 연결이 원활하지 않습니다.", message: "와이파이나 데이터 연결을 확인해주세요", preferredStyle: .alert)
        // 확인 버튼 누르면 앱 재실행
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            exit(0)
                        }
        alert.addAction(okAction)

        monitor.start(queue: .global())
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("연결되있음")
                
            } else {
                print("연결끊겨있음")
                
                DispatchQueue.main.async {
                    UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
                }
            }
        }
    }
    
    func checkLoginInfo() {
        let checkLogin = UserDefault().loadCheckLoginUserDefault()
        
        let loginType = checkLogin.lastLogin
        
        switch loginType {
        case .kakao:
            print("kakao")
            checkKakaoSignIn()
            
        case .google:
            print("google")
            checkGoogleAppleSignIn()
            
        case .apple:
            print("apple")
            checkGoogleAppleSignIn()
            
        case .normal:
            print("normal")
        case .nothing:
            print("nothing")
            
        }

    }
    
    // 카카오 로그인 체크
    func checkKakaoSignIn() {
        
        if (AuthApi.hasToken()) {
            
            print("일단 카카오 토큰은 있음")
            UserApi.shared.accessTokenInfo {(accessTokenInfo, error) in
                if let error = error {
                    print("토큰 access 에러")
                    print(error)
                }
                else {
                    
                    print("accessTokenInfo() success.")
                    self.showMainViewController()
                }
            }
        }
        else {
            print("카카오 토큰이 없음")
            //로그인 필요
        }
    }

    
    func checkGoogleAppleSignIn() {
        if let user = Auth.auth().currentUser {
            print(user)
            self.showMainViewController()
        } else {
            return
        }
    }
    
    
    

    // 애플 로그인이 되어있는지 확인
    func checkAppleSignIn(token: String) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: token) { (credentialState, error) in
            switch credentialState {
                
            // 이미 증명이 된경우
            case .authorized:
                print("authorized")
                
            // revoke, notfound
            default:
                print("revoke or notfound")
                break
            }
        }
    }
    
    // main tabbar 이동
    private func showMainViewController() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainTabbar")
            mainViewController.modalPresentationStyle = .fullScreen
            UIApplication.shared.windows.first?.rootViewController?.show(mainViewController, sender: nil)
        }
    }
}

extension UIViewController {

    // 뷰를 클릭하면 키보드가 내려감
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        print("tab")
        view.endEditing(true)
    }

}
