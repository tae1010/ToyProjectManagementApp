//
//  ChangeProjectPrograssViewController.swift
//  ToyProjectManagementApp
//
//  Created by 김정태 on 2022/10/02.
//

import Foundation
import UIKit

class ChangeProjectPrograssViewController: UIViewController {
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var projectPrograssLabel: UILabel!
    @IBOutlet weak var statusPrograssLabel: UILabel!
    @IBOutlet weak var prograssSwitch: UISwitch!
    
    var projectTitle: String?
    var projectPrograss: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.touchBackGround()
        self.configure()
    }
    
    @IBAction func changePrograssSwitch(_ sender: UISwitch) {
        if sender.isOn {
            self.statusPrograssLabel.text = "진행중"
            self.projectPrograss = true
        }
        else {
            self.statusPrograssLabel.text = "완료"
            self.projectPrograss = false
        }
    }
    
    
    @IBAction func tapCancelButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func tabChangePrograssButton(_ sender: UIButton) {
        NotificationCenter.default.post(name: .changePrograssProjectNotification, object: projectPrograss, userInfo: nil)
        self.dismiss(animated: true)
    }
    
    private func touchBackGround() {
        let tabBackGroundView = UITapGestureRecognizer(target: self, action: #selector(tabBackGroundSelector))
        self.backgroundView.addGestureRecognizer(tabBackGroundView)
        self.backgroundView.isUserInteractionEnabled = true
    }
    
    @objc func tabBackGroundSelector(sender: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }
    
}

extension ChangeProjectPrograssViewController {
    
    private func configure() {
        self.configurePopupView()
        self.configureStatusPrograssLabel()
        self.configureProjectPrograssLabel()
        self.configurePrograssSwitch()
    }
    
    private func configurePopupView() {
        self.popupView.layer.cornerRadius = 8
    }
    
    private func configureProjectPrograssLabel() {
        
        guard let projectTitle = self.projectTitle else { return }
        
        self.projectPrograssLabel.font = UIFont(name: "NanumGothicOTFBold", size: 15)
        self.projectPrograssLabel.text = "\(projectTitle) 상태"
    }
    
    private func configureStatusPrograssLabel() {
        
        guard let projectPrograss = self.projectPrograss else { return }
        self.statusPrograssLabel.font = UIFont(name: "NanumGothicOTF", size: 15)
        self.statusPrograssLabel.text = projectPrograss ? "진행중" : "완료"
    }
    
    private func configurePrograssSwitch() {
        guard let projectPrograss = self.projectPrograss else { return }
        prograssSwitch.isOn = projectPrograss
    }
}
