//
//  CustomTabbarViewController.swift
//  ToyProjectManagementApp
//
//  Created by 김정태 on 2022/11/07.
//

import UIKit

class CustomTabbarViewController: UITabBarController {

    var borderView: UIView!

    var projectCount = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customTabbar()
        self.setupBorderView()
        view.bringSubviewToFront(tabBar)
        
        self.delegate = self
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("??????????")
        
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }
    
    
    
    func setBadge(notificationModel: [NotificationModel]) {

        print(#fileID, #function, #line, "- configureBadge")
        var trueBadgeCount = notificationModel // 확인하지 않은 알림 cell(badge수) count 저장
        
        trueBadgeCount = notificationModel.filter({
            $0.badge == true
        })
        
        if let tabItems = tabBarController?.tabBar.items {
            print("값이 있다")
            let tabItem = tabItems[1]
            tabItem.badgeValue = trueBadgeCount.count == 0 ? nil : "\(trueBadgeCount.count)"
    
        } else {
            print("값이 없다")
        }
        
    }
    
    
    // 텝바
    private func customTabbar() {
        self.tabBar.unselectedItemTintColor = .black
    }
    
    // 텝바 뒤에 회색 선
    private func setupBorderView() {
        borderView = UIView(frame: .zero)
        borderView.translatesAutoresizingMaskIntoConstraints = false

        borderView.backgroundColor = .veryLightGray

        view.addSubview(borderView)
        borderView.widthAnchor.constraint(equalToConstant: tabBar.frame.width + 3).isActive = true
        borderView.heightAnchor.constraint(equalToConstant: tabBar.frame.height).isActive = true
        borderView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        borderView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -1).isActive = true
    }
    

}

extension CustomTabbarViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if viewController == ForthTabbarViewController() {

            let forthTabbarViewController = self.viewControllers![0] as!
            ForthTabbarViewController //first view controller in the tabbar

            
        }
    }
       
}


