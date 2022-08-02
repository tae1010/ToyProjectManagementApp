//
//  CustomSideMenuNavigation.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/08/02.
//

import UIKit
import SideMenu

class CustomSideMenuNavigation: SideMenuNavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSideMenu()
    }
    
    func setUpSideMenu() {
        //메뉴 나오는 스타일
        self.presentationStyle = .menuSlideIn
        //뒤에 배경색 설정
        self.presentationStyle.backgroundColor = .black
        //뒤에 배경 alpha값 설정
        self.presentationStyle.presentingEndAlpha = 0.7
        
        //self.statusBarEndAlpha = 0.0
//        self.menuWidth = (UIScreen.main.bounds.width / 5) * 4
    }
    
}
