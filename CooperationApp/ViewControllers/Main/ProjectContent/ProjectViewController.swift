//
//  ProjectViewController.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/05/11.
//

import UIKit

class ProjectViewController: UIViewController {

    @IBOutlet weak var pratice: UILabel!
    var index: Int = 0
    var string: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.string = String(index)
        pratice.text = string
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: false)
    }
}
