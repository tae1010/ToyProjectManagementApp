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
    
    // project 완료 여부 notification (reallyCheckPopupViewController에서 post를 하면 MainTabbar에서 changePrograssProject함수 실행)
    static let changePrograssProjectNotification = Notification.Name("changePrograssProjectNotification")
    
    // 리스트 추가 notification
    static let addListNotificaton = Notification.Name("addListNotificaton")
    
    // 카드 추가 notification
    static let addCardNotificaton = Notification.Name("addCardNotificaton")
    
    // project 이름 변경 notificatioin
    static let changeProjectTitleNotification = Notification.Name("changeProjectTitleNotification")
    
    // 마이페이지 프로젝트 수, 진행중, 완료 count전달 notification
    static let projectCountNotification = Notification.Name("projectCountNotification")
}
