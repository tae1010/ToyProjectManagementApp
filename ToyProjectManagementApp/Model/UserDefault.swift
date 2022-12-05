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
    
    var sortNotificationModel = [NotificationModel]()
    
    // set 기본로그인 id password
    func setNormalLoginUserDefault(id: String, password: String) {
        userDefault.set(id, forKey: "normalLoginId")
        userDefault.set(password, forKey: "normalLoginPassWord")
    }
    
    // load 기본로그인 id
    func loadNormalLoginIdUserDefault() -> String {
        guard let loadNormalLoginId = userDefault.object(forKey: "normalLoginId") as? String else { return "" }
        return loadNormalLoginId
    }
    
    // load 기본로그인 password
    func loadNormalLoginPassWordUserDefault() -> String {
        guard let loadNormalLoginPassWord = userDefault.object(forKey: "normalLoginPassWord") as? String else { return "" }
        return loadNormalLoginPassWord
    }
    
    // 최초 로그인시 토큰, 로그인 방식 저장
    func setLoginDataUserDefault(checkLogin: CheckLogin) {
        let checkLoginEncoder = try? encoder.encode(checkLogin)
        
        print(checkLogin, "어떤 로그인인지 체크")
        
        userDefault.set(checkLoginEncoder, forKey: "checkLogin")
    }
    
    func loadCheckLoginUserDefault() -> CheckLogin {
        guard let checkLogin = userDefault.object(forKey: "checkLogin") else { return CheckLogin(lastLogin: .nothing) }
        guard let checkLoginDecoder = try? decoder.decode(CheckLogin.self, from: checkLogin as! Data) else { return CheckLogin(lastLogin: .nothing) }
        
        return checkLoginDecoder
    }

    // notification model 삭제
    func removeNotificationModelUserDefault() {
        UserDefaults.standard.removeObject(forKey: "notificationModel")
    }
    
    // notification model 저장
    func setNotificationModelUserDefault(notificationModel: [NotificationModel]) {
        
        let notificationModelEncoder = try? encoder.encode(notificationModel)

        userDefault.set(notificationModelEncoder, forKey: "notificationModel")
    }
    
    // Notification Model 불러오기
    func loadNotificationModelUserDefault() -> [NotificationModel]? {
        guard let notificationModel = userDefault.object(forKey: "notificationModel") else { return [NotificationModel]() }
        guard let notificationModelDecoder = try? decoder.decode([NotificationModel].self, from: notificationModel as! Data) else { return [NotificationModel]() }

        return notificationModelDecoder
    }
    
    // notification Model 1개씩 update -> sort -> 저장
    func notificationModelUserDefault(title: String, status: String, content: String, date: Int, badge: Bool) {
        var notificationModel: [NotificationModel] = UserDefault().loadNotificationModelUserDefault() ?? [NotificationModel]()

        notificationModel.append(NotificationModel(projectTitle: title, status: status, content: content, date: date, badge: badge))

        let sortNotificationModel = sortModel(notificationModel: notificationModel)

        UserDefault().setNotificationModelUserDefault(notificationModel: sortNotificationModel)
        
    }
    
    // 정렬하고 10개 이상이면 지워줌
    func sortModel(notificationModel: [NotificationModel]) -> [NotificationModel] {
        var sortNotificationModel = notificationModel.sorted(by: {$0.date > $1.date})

        if sortNotificationModel.count > 10 {
            sortNotificationModel.removeLast()
        }
        
        return sortNotificationModel
    }
    
    
    /// return badge수
    // 텝바 컨트롤러 안에서 일어나는 set userdefault들은 badge를 직접 적어야함 (customTabbarController 안에서 set badge함수를 사용하려고 하면 tabbar.item이 nil값이라고 떠서 실행이 안됨)
    func setBadgeCount() -> Int {
        let notificationModel: [NotificationModel] = UserDefault().loadNotificationModelUserDefault() ?? [NotificationModel]()
        
        var trueBadgeCount = notificationModel

        trueBadgeCount = notificationModel.filter({
            $0.badge == true
        })
        
        return trueBadgeCount.count
    }
}
