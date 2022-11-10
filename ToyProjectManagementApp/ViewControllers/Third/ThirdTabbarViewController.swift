//
//  MainTabbarViewController.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/04/07.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ThirdTabbarViewController: UIViewController {
    
    @IBOutlet weak var notificationTitleLabel: UILabel!
    @IBOutlet weak var notificationTableView: UITableView!
    
    var notificationModel = [NotificationModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNotificationTitleLabel()
        self.configureNotificationTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.notificationModel = UserDefault().loadNotificationModelUserDefault() ?? [NotificationModel]()
        self.notificationTableView.reloadData()
    }

}

extension ThirdTabbarViewController {
    
    private func configureNotificationTableView() {
        self.notificationTableView.delegate = self
        self.notificationTableView.dataSource = self
        
        let tableViewNib = UINib(nibName: "NotificationCell", bundle: nil)
        self.notificationTableView.register(tableViewNib, forCellReuseIdentifier: "NotificationCell")
    }
    
    private func configureNotificationTitleLabel() {
        self.notificationTitleLabel.font = UIFont(name: "NanumGothicOTFBold", size: 20)
    }
    
    private func emailToString(_ email: String) -> String {
        let emailToString = email.replacingOccurrences(of: ".", with: ",")
        return emailToString
    }
    
}

extension ThirdTabbarViewController: UITableViewDelegate {
    
}

extension ThirdTabbarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notificationModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell

        cell.notificaionImageView.image = {
            
            var status = notificationModel[indexPath.row].status
            
            if status == "생성" {
                return UIImage(named: "create")
            } else if status == "삭제" {
                return UIImage(named: "delete")
            } else if status == "위아래이동" {
                return UIImage(named: "moveUpDown")
            } else if status == "양옆이동" {
                return UIImage(named: "moveLeftRight")
            } else {
                return UIImage(named: "changeStatus")
            }
        }()
        
        cell.notificatioinProjectTitleLabel.text = notificationModel[indexPath.row].projectTitle
        cell.notificationProjectContentTitleLabel.text = notificationModel[indexPath.row].projectTitle
        cell.notificationContentLabel.text = notificationModel[indexPath.row].content
        cell.notificationDateLabel.text = changeDateLabel(date: notificationModel[indexPath.row].date)
        
        return cell
    }

    // 20200101111111 -> 2020-01-01
    private func changeDateLabel(date: Int) -> String {

        var dateText = String(date)
        
        dateText.insert("-", at: dateText.index(dateText.startIndex, offsetBy: 4))
        dateText.insert("-", at: dateText.index(dateText.startIndex, offsetBy: 7))
        dateText.insert(" ", at: dateText.index(dateText.startIndex, offsetBy: 10))
        dateText.insert(":", at: dateText.index(dateText.startIndex, offsetBy: 13))
        
        let result = String(dateText.dropLast(2))

        return result
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    
}
