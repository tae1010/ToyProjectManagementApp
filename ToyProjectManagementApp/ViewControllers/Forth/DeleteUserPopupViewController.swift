//
//  DeleteUserPopupViewController.swift
//  ToyProjectManagementApp
//
//  Created by 김정태 on 2022/11/24.
//

import Foundation
import UIKit
import FirebaseAuth

protocol DeleteUserDelegate: AnyObject {
    func deleteUserDelegate()
}

class DeleteUserPopupViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var deleteUserLabel: UILabel!
    @IBOutlet weak var deleteUserContentLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var deleteUserButton: UIButton!
    
    weak var deleteUserDelegate: DeleteUserDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    @IBAction func tapCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func tapDeleteUserButton(_ sender: UIButton) {
        self.deleteUserDelegate?.deleteUserDelegate()
        UserDefault().removeNotificationModelUserDefault()
        self.dismiss(animated: true)
    }
    
}

extension DeleteUserPopupViewController {
    
    private func configure() {
        self.configureContentView()
        self.configurePopupTitleLabel()
        self.configureDeleteButton()
        self.configureCancelButton()
    }
    
    private func configureContentView() {
        self.contentView.layer.cornerRadius = 8
    }
    
    private func configurePopupTitleLabel() {
        self.deleteUserLabel.font = UIFont(name: "NanumGothicOTF", size: 14)
        self.deleteUserContentLabel.font = UIFont(name: "NanumGothicOTFLight", size: 12)
    }
    
    private func configureCancelButton() {
        self.cancelButton.titleLabel?.font = UIFont(name: "NanumGothicOTF", size: 14)
    }
    
    private func configureDeleteButton() {
        self.deleteUserButton.titleLabel?.font = UIFont(name: "NanumGothicOTF", size: 14)
    }
}
