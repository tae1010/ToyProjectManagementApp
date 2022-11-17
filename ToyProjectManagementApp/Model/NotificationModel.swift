//
//  NotificationModel.swift
//  ToyProjectManagementApp
//
//  Created by 김정태 on 2022/11/08.
//

import Foundation

// 알림 뷰(third tabbar) model
struct NotificationModel: Codable {
    var projectTitle: String
    var status: String
    var content: String
    var date: Int
    var badge: Bool // badge가 떠있으면 true 안 떠있으면 false
}

