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


}
