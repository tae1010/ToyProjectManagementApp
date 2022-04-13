//
//  ThirdTabbarViewController.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/04/13.
//

import UIKit

class MainTabbarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }

}
