//
//  MainTabbarViewController.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/04/07.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import DropDown
import Toast_Swift

class ThirdTabbarViewController: UIViewController {
    
    @IBOutlet weak var notificationTitleLabel: UILabel!
    @IBOutlet weak var notificationTableView: UITableView!
    @IBOutlet weak var notificationAlertLabel: UILabel!
    @IBOutlet weak var notificationContentLabel: UILabel!
    @IBOutlet weak var notificationMenuButton: UIButton!
    
    var notificationModel = [NotificationModel]()
    let dropDown = DropDown() // dropdown 객체
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNotificationTitleLabel()
        self.configureNotificationTableView()
        self.configureNotificationAlertLabel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.notificationModel = UserDefault().loadNotificationModelUserDefault() ?? [NotificationModel]()
        self.notificationAlertLabel.text = "\(self.notificationModel.count)개의 알림"
        self.notificationTableView.reloadData()
        
        self.checkBadge()
    }
    
    // 화면을 종료하면 userDefault 업데이트 하기
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefault().removeNotificationModelUserDefault()
        UserDefault().setNotificationModelUserDefault(notificationModel: self.notificationModel)
    }
    
    /// 알림뷰 알림 전부 삭제
    @IBAction func tabNotificationMenu(_ sender: UIButton) {
        self.configureDropDown()
        
        dropDown.selectionAction = { [weak self] (index, item) in
                //선택한 Item을 TextField에 넣어준다.
            
            index == 0 ? self?.checkNotificationModel() : self?.removeNotificationModel()
            

        }
    }
    
    // 알림 내역 전부 삭제
    private func removeNotificationModel() {
        if self.notificationModel.count == 0 {
            self.view.hideAllToasts()
            self.view.makeToast("알림수가 0개입니다.", duration: 1)
            return
        }
        
        UserDefault().removeNotificationModelUserDefault()
        notificationModel.removeAll()
        self.notificationAlertLabel.text = "\(self.notificationModel.count)개의 알림"
        self.notificationTableView.reloadData()
        
        self.view.hideAllToasts()
        self.view.makeToast("알림이 삭제되었습니다", duration: 1)
    }
    
    // 알림내역 전부 확인 후 badge 0으로하기
    private func checkNotificationModel() {
        
        for i in 0...notificationModel.count - 1 {
            self.notificationModel[i].badge = false
            print(self.notificationModel[i].badge)
        }
        self.checkBadge()
        
        self.view.hideAllToasts()
        self.view.makeToast("알림을 전부 확인하였습니다", duration: 1)
        
        DispatchQueue.main.async {
            self.notificationTableView.reloadData()
        }
        
    }
}

extension ThirdTabbarViewController {
    
    private func configureNotificationTableView() {
        self.notificationTableView.delegate = self
        self.notificationTableView.dataSource = self
        
        self.notificationTableView.rowHeight = UITableView.automaticDimension
        self.notificationTableView.estimatedRowHeight = 90
        
        let tableViewNib = UINib(nibName: "NotificationCell", bundle: nil)
        self.notificationTableView.register(tableViewNib, forCellReuseIdentifier: "NotificationCell")
    }
    
    private func configureNotificationTitleLabel() {
        self.notificationTitleLabel.font = UIFont(name: "NanumGothicOTFBold", size: 20)
        
    }
    
    private func configureNotificationAlertLabel() {
        self.notificationAlertLabel.font = UIFont(name: "NanumGothicOTF", size: 13)
        self.notificationContentLabel.font = UIFont(name: "NanumGothicOTF", size: 13)
        self.notificationAlertLabel.textColor = UIColor(red: 0.412, green: 0.42, blue: 0.446, alpha: 1)
        self.notificationContentLabel.textColor = UIColor(red: 0.412, green: 0.42, blue: 0.446, alpha: 1)
    }
    
    
    private func configureDropDown() {
        
        let notificationMenu = ["알림모두확인","알림지우기"]
        dropDown.dataSource = notificationMenu // dropdown data
        
        // dropdown 위치
        dropDown.anchorView = self.notificationMenuButton
        dropDown.bottomOffset = CGPoint(x: -40, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.textColor = UIColor(red: 0.412, green: 0.42, blue: 0.446, alpha: 1)
        dropDown.selectedTextColor = UIColor.red
        dropDown.textFont = UIFont(name: "NanumGothicOTF", size: 14) ?? UIFont.systemFont(ofSize: 14)
        dropDown.backgroundColor = UIColor.white
        dropDown.selectionBackgroundColor = UIColor.white
        dropDown.cornerRadius = 5
        
        
        dropDown.show()
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
                return UIImage(named: "create_Black")
            } else if status == "삭제" {
                return UIImage(named: "delete_Black")
            } else if status == "위아래이동" {
                return UIImage(named: "move")
            } else if status == "양옆이동" {
                return UIImage(named: "move")
            } else {
                return UIImage(named: "changeStatus_Black")
            }
        }()
        
        cell.cellBadge.isHidden = !notificationModel[indexPath.row].badge
        cell.notificationContentLabel.text = "\(notificationModel[indexPath.row].content)"
        cell.notificationDateLabel.text = changeDateLabel(date: notificationModel[indexPath.row].date)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        notificationModel[indexPath.row].badge = false
        
        // badge 업데이트
        self.checkBadge()
        self.notificationTableView.reloadRows(at: [indexPath], with: .none)
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
    
    /// 2번째 텝바에 badge 띄우기
    private func checkBadge() {
        var trueBadgeCount = self.notificationModel // 확인하지 않은 알림 cell(badge수) count 저장
        
        trueBadgeCount = notificationModel.filter({
            $0.badge == true
        })
        
        tabBarController?.tabBar.items?[1].badgeValue = trueBadgeCount.count == 0 ? nil : "\(trueBadgeCount.count)"
    }
}
