//
//  CheckLogin.swift
//  ToyProjectManagementApp
//
//  Created by 김정태 on 2022/11/30.
//

import Foundation
import UIKit

struct CheckLogin: Codable {
//    var token: String
    var lastLogin: Login
    
    // login type
    enum Login: String, Codable {
        case apple
        case kakao
        case google
        case normal
        case nothing
        
        var create: String {
            switch self {
            case .apple:
                return "apple"
            case .kakao:
                return "kakao"
            case .google:
                return "google"
            case .normal:
                return "normal"
            default:
                return "nothing"
            }
        }
    }

    
    init(lastLogin: Login) {
        //self.token = token
        self.lastLogin = lastLogin
    }
    
}
