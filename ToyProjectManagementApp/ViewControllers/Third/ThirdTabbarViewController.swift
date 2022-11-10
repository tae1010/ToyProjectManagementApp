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
    @IBOutlet weak var notificationAlertLabel: UILabel!
    @IBOutlet weak var removeNotificationModelButton: UIButton!
    
    var notificationModel = [NotificationModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNotificationTitleLabel()
        self.configureNotificationTableView()
        self.configureNotificationAlertLabel()
        self.configureRemoveNotificationModelButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.notificationModel = UserDefault().loadNotificationModelUserDefault() ?? [NotificationModel]()
        self.notificationAlertLabel.text = "\(self.notificationModel.count)개의 알림"
        self.notificationTableView.reloadData()
    }
    
    @IBAction func tapRemoveNotificationModel(_ sender: UIButton) {
        
        if self.notificationModel.count == 0 {
            self.view.hideToast()
            self.view.makeToast("알림수가 0개입니다.", duration: 1)
            return
        }
        
        UserDefault().removeNotificationModelUserDefault()
        notificationModel.removeAll()
        self.notificationAlertLabel.text = "\(self.notificationModel.count)개의 알림"
        self.notificationTableView.reloadData()
        
        self.view.hideToast()
        self.view.makeToast("알림이 삭제되었습니다", duration: 1)
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
    
    private func configureNotificationAlertLabel() {
        self.notificationAlertLabel.font = UIFont(name: "NanumGothicOTF", size: 14)
        self.notificationAlertLabel.textColor = UIColor(red: 0.412, green: 0.42, blue: 0.446, alpha: 1)
    }
    
    private func configureRemoveNotificationModelButton() {
        self.removeNotificationModelButton.titleLabel?.font = UIFont(name: "NanumGothicOTF", size: 14)
        self.removeNotificationModelButton.tintColor = UIColor(red: 0.412, green: 0.42, blue: 0.446, alpha: 1)
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
        cell.selectionStyle = .none

        cell.notificaionImageView.image = {
            
            let status = notificationModel[indexPath.row].status
            
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
