//
//  ExtensionNotification.swift
//  ToyProjectManagementApp
//
//  Created by 김정태 on 2022/10/01.
//

import Foundation
import UIKit


extension Notification.Name {
    
    // project 삭제 notification (reallyCheckPopupViewController에서 post를 하면 MainTabbar에서 deleteProject함수 실행)
    static let deleteProjectNotification = Notification.Name("deleteProjectNotification")
    
    // project 완료 여부 notofication (reallyCheckPopupViewController에서 post를 하면 MainTabbar에서 changePrograssProject함수 실행)
    static let changePrograssProjectNotification = Notification.Name("changePrograssProjectNotification")
}
