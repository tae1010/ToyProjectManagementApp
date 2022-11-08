//
//  CustomTabbarViewController.swift
//  ToyProjectManagementApp
//
//  Created by 김정태 on 2022/11/07.
//

import UIKit

class CustomTabbarViewController: UITabBarController {

    var borderView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customTabbar()
        self.setupBorderView()
        view.bringSubviewToFront(tabBar)
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
