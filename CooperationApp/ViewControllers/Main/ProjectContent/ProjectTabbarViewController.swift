//
//  ProjectTabbarViewController.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/05/11.
//

import UIKit

class ProjectTabbarViewController: UITabBarController {
    
    var id: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.transdata()
        
        // Do any additional setup after loading the view.
    }
    
    private func transdata() {
        guard let projectViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProjectViewController") as? ProjectViewController else { return }
        
    }
}
