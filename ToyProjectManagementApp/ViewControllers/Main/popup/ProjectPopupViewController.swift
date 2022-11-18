//
//  ProjectPopupViewController.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/06/17.
//

import UIKit
import MaterialComponents.MaterialBottomSheet

class ProjectPopupViewController: UIViewController {

    @IBOutlet weak var popUpView: UIView!
    @IBOutlet var backGroundView: UIView!
    
    @IBOutlet weak var changeProjectTitleButton: UIButton!
    @IBOutlet weak var changePrograssButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var projectPrograss: Bool?
    var projectTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.touchBackGround()
        self.configurePopUpView()
        self.configureButton()
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
    
    
    @IBAction func cellChangeTitle(_ sender: UIButton) {
        guard let pvc = self.presentingViewController else { return } // maintabbarViewController
        
        let changeProjectTitlePopup = ChangeProjectTitlePopupViewController(nibName: "ChangeProjectTitlePopup", bundle: nil)
        changeProjectTitlePopup.view.layer.cornerRadius = 20
        changeProjectTitlePopup.modalPresentationStyle = .overCurrentContext
        changeProjectTitlePopup.modalTransitionStyle = .crossDissolve // 뷰가 투명해지면서 넘어가는 애니메이션

        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: changeProjectTitlePopup)
        bottomSheet.mdc_bottomSheetPresentationController?.preferredSheetHeight = self.view.bounds.size.height * 0.3
        
        self.dismiss(animated: true) {
            pvc.present(bottomSheet, animated: false, completion: nil)
        }
    }
    
    @IBAction func cellChangePrograss(_ sender: UIButton) {
        guard let pvc = self.presentingViewController else { return } // maintabbarViewController

        let changeProjectPrograssPopup = ChangeProjectPrograssViewController(nibName: "ChangeProjectPrograssPopup", bundle: nil)
        
        changeProjectPrograssPopup.view.layer.cornerRadius = 20
        changeProjectPrograssPopup.modalPresentationStyle = .overCurrentContext
        changeProjectPrograssPopup.modalTransitionStyle = .crossDissolve // 뷰가 투명해지면서 넘어가는 애니메이션
        changeProjectPrograssPopup.projectPrograss = projectPrograss
        changeProjectPrograssPopup.projectTitle = projectTitle
        print(projectPrograss, "이것도확인")
        // 기존팝업창은 지우고 reallyCheckPopup창을 띄움
        self.dismiss(animated: true) {
            pvc.present(changeProjectPrograssPopup, animated: true, completion: nil)
        }
    }
    
    @IBAction func cellDelete(_ sender: UIButton) {
        guard let pvc = self.presentingViewController else { return } // maintabbarViewController

        let reallyCheckPopup = ReallyCheckPopupViewController(nibName: "ReallyCheckPopup", bundle: nil)
        
        reallyCheckPopup.modalPresentationStyle = .overCurrentContext
        reallyCheckPopup.modalTransitionStyle = .crossDissolve // 뷰가 투명해지면서 넘어가는 애니메이션

        // 기존팝업창은 지우고 reallyCheckPopup창을 띄움
        self.dismiss(animated: true) {
            pvc.present(reallyCheckPopup, animated: true, completion: nil)
        }
    }

}

extension ProjectPopupViewController {
    
    private func configurePopUpView() {
        self.popUpView.layer.cornerRadius = 8
    }
    
    private func configureButton() {
        self.changePrograssButton.titleLabel?.font = UIFont(name: "NanumGothicOTF", size: 14)
        self.deleteButton.titleLabel?.font = UIFont(name: "NanumGothicOTF", size: 14)
        self.deleteButton.setTitleColor(.red, for: .normal)
    }
    
}
