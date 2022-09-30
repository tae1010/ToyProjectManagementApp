//
//  ProjectPopupViewController.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/06/17.
//

import UIKit

class ProjectPopupViewController: UIViewController {

    @IBOutlet weak var popUpView: UIView!
    @IBOutlet var backGroundView: UIView!
    
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!

    var cellIndex: Int = 0
    var section: Int = 0
    var prograss: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.touchBackGround()
        self.configurePopUpView()
        self.configureButton()
    }
    
    private func configurePopUpView() {
        self.popUpView.layer.cornerRadius = 8
    }
    
    private func configureButton() {
        self.infoButton.titleLabel?.font = UIFont(name: "NanumGothicOTF", size: 14)
        self.deleteButton.titleLabel?.font = UIFont(name: "NanumGothicOTF", size: 14)
        self.deleteButton.setTitleColor(.red, for: .normal)
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
//        self.sendTagDelegate?.sendSender(index: cellIndex, session: session, tag: sender.tag)
        self.dismiss(animated: true)
    }
    
    @IBAction func cellDelete(_ sender: UIButton) {

        guard let pvc = self.presentingViewController else { return } // maintabbarViewController

        let reallyCheckPopup = ReallyCheckPopupViewController(nibName: "ReallyCheckPopup", bundle: nil)
        
        reallyCheckPopup.cellIndex = self.cellIndex
        reallyCheckPopup.section = self.section
        reallyCheckPopup.tag = sender.tag
        
        reallyCheckPopup.modalPresentationStyle = .overCurrentContext
        reallyCheckPopup.modalTransitionStyle = .crossDissolve // 뷰가 투명해지면서 넘어가는 애니메이션
        self.present(reallyCheckPopup, animated: true, completion: nil)
//        pvc.present(reallyCheckPopup, animated: true, completion: nil)

//        // 기존팝업창은 지우고 reallyCheckPopup창을 띄움
//        self.dismiss(animated: true) {
//
//
//        }
    }
}
