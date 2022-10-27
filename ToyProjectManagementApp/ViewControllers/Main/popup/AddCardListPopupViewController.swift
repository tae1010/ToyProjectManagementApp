//
//  AddCardListPopupViewController.swift
//  ToyProjectManagementApp
//
//  Created by 김정태 on 2022/10/13.
//

import Foundation
import UIKit
import MaterialComponents.MaterialBottomSheet

class AddCardListPopupViewController: UIViewController {
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var popUpView: UIView!
    
    @IBOutlet weak var addCardButton: UIButton!
    @IBOutlet weak var addListButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.touchBackGround()
        self.configureAddCardButton()
        self.configureAddListButton()
        self.configurePopupView()
    }
    
    @IBAction func tapAddCardButton(_ sender: UIButton) {
        showBottomSheet(nibName: "AddCardPopup")
    }
    
    @IBAction func tapAddListbutton(_ sender: UIButton) {
        showBottomSheet(nibName: "AddListPopup")
    }
    
    private func showBottomSheet(nibName: String) {
        
        let addListCardPopup = nibName == "AddCardPopup" ? AddCardPopupViewController(nibName: "\(nibName)", bundle: nil) : AddListPopupViewController(nibName: "\(nibName)", bundle: nil)
        
        guard let pvc = self.presentingViewController else { return } // ProjectContentViewController
        
        addListCardPopup.view.clipsToBounds = false
        addListCardPopup.view.layer.cornerRadius = 20
        
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: addListCardPopup)
        bottomSheet.mdc_bottomSheetPresentationController?.preferredSheetHeight = self.view.bounds.size.height * 0.3
        
        self.dismiss(animated: true) {
            pvc.present(bottomSheet, animated: true, completion: nil)
        }
    }
    
    private func touchBackGround() {
        let tabBackGroundView = UITapGestureRecognizer(target: self, action: #selector(tabBackGroundSelector))
        self.backgroundView.addGestureRecognizer(tabBackGroundView)
        self.backgroundView.isUserInteractionEnabled = true
    }
    
    // 백 그라운드 클릭시 팝업창 닫기
    @objc func tabBackGroundSelector(sender: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }

}

// MARK: - configure
extension AddCardListPopupViewController {
    
    private func configurePopupView() {
        self.popUpView.layer.cornerRadius = 8
    }
    
    private func configureAddCardButton() {
        self.addCardButton.titleLabel?.font = UIFont(name: "NanumGothicOTF", size: 14)
    }
    
    private func configureAddListButton() {
        self.addListButton.titleLabel?.font = UIFont(name: "NanumGothicOTF", size: 14)
    }
}
