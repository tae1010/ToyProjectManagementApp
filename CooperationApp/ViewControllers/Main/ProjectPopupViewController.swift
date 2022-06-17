//
//  ProjectPopupViewController.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/06/17.
//

import UIKit

class ProjectPopupViewController: UIViewController {

    @IBOutlet var backGroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabBackGroundView = UITapGestureRecognizer(target: self, action: #selector(tabBackGroundSelector))
        self.backGroundView.addGestureRecognizer(tabBackGroundView)
        self.backGroundView.isUserInteractionEnabled = true
    }
    
    //백 그라운드 클릭시 팝업창 닫기
    @objc func tabBackGroundSelector(sender: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }
    
    @IBAction func cellInfo(_ sender: UIButton) {
    }
    
    @IBAction func cellDelete(_ sender: UIButton) {
        
    }
}
