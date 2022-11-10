//
//  UserDefault.swift
//  ToyProjectManagementApp
//
//  Created by 김정태 on 2022/11/01.
//

import Foundation


class UserDefault {
    
    let userDefault = UserDefaults.standard
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    func setNotificationModelUserDefault(notificationModel: [NotificationModel]) {
        
        var notificationModelEncoder = try? encoder.encode(notificationModel)
        userDefault.set(notificationModelEncoder, forKey: "notificationModel")
    }
    
    // Notification Model 불러오기
    func loadNotificationModelUserDefault() -> [NotificationModel]? {
        guard let notificationModel = userDefault.object(forKey: "notificationModel") else { return [NotificationModel]() }
        guard let notificationModelDecoder = try? decoder.decode([NotificationModel].self, from: notificationModel as! Data) else { return [NotificationModel]() }

        return notificationModelDecoder
    }
    
    func notificationModelUserDefault(title: String, status: String, content: String, date: Int) {
        var notificationModel: [NotificationModel] = UserDefault().loadNotificationModelUserDefault() ?? [NotificationModel]()

        notificationModel.append(NotificationModel(projectTitle: title, status: status, content: content, date: date))

        var sortNotificationModel = notificationModel.sorted(by: {$0.date > $1.date})

        if sortNotificationModel.count > 10 {
            sortNotificationModel.removeLast()
        }

        UserDefault().setNotificationModelUserDefault(notificationModel: notificationModel)
    }
}
