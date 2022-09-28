//
//  ProjectPopupViewController.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/06/17.
//

import UIKit

// projectCollectionView 팝업창 버튼 delegate
protocol SendButtonTagDelegate : AnyObject{
    func sendSender(index: Int, session: Int, tag: Int)
}

class ProjectPopupViewController: UIViewController {

    @IBOutlet var backGroundView: UIView!
    
    weak var sendTagDelegate: SendButtonTagDelegate?
    var cellIndex: Int = 0
    var session: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.touchBackGround()
    }
    
    // 백 그라운드 클릭
    private func touchBackGround() {
        let tabBackGroundView = UITapGestureRecognizer(target: self, action: #selector(tabBackGroundSelector))
        self.backGroundView.addGestureRecognizer(tabBackGroundView)
        self.backGroundView.isUserInteractionEnabled = true
    }
    
    // 백 그라운드 클릭시 팝업창 닫기
    @objc func tabBackGroundSelector(sender: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }
    
    @IBAction func cellInfo(_ sender: UIButton) {
        print(sender.tag)
        self.sendTagDelegate?.sendSender(index: cellIndex, session: session, tag: sender.tag)
        self.dismiss(animated: true)
    }
    
    @IBAction func cellDelete(_ sender: UIButton) {
        print(sender.tag)
        self.sendTagDelegate?.sendSender(index: cellIndex, session: session, tag: sender.tag)
        self.dismiss(animated: true)
    }
}
