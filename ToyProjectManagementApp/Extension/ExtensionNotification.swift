//
//  ExtensionNotification.swift
//  ToyProjectManagementApp
//
//  Created by 김정태 on 2022/10/01.
//

import Foundation
import UIKit

// project 삭제 notification (reallyCheckPopupViewController에서 post를 하면 MainTabbar에서 deleteProject함수 실행)
extension Notification.Name {
    static let deleteProjectNotification = Notification.Name("deleteProjectNotification")
}
