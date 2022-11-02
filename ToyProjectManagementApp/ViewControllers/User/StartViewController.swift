//
//  StartViewController.swift
//  ToyProjectManagementApp
//
//  Created by 김정태 on 2022/09/22.
//

import Foundation
import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var alreadyExistAccountButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureBackGroundView()
        self.configureButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(#fileID, #function, #line, "- ")
        self.configureBackGroundView()
        self.configureButton()
    }
    
    @IBAction func tapAlreadyExistAccountButton(_ sender: UIButton) {
        guard let loginView = self.storyboard?.instantiateViewController(withIdentifier: "loginViewController") else { return }
        self.navigationController?.pushViewController(loginView, animated: false)
    }
    
    @IBAction func tapSignUpButton(_ sender: UIButton) {
        guard let signUpView = self.storyboard?.instantiateViewController(withIdentifier: "signUpViewController") else { return }
        self.navigationController?.pushViewController(signUpView, animated: false)
    }
    
}

extension StartViewController {
    
    private func configureBackGroundView() {
        self.view.backgroundColor = .primaryColor
    }
    
    private func configureButton() {
        self.alreadyExistAccountButton.layer.cornerRadius = 8
        self.signUpButton.layer.cornerRadius = 8
        self.alreadyExistAccountButton.titleLabel?.font = UIFont(name: "NanumGothicOTFBold", size: 14)
        self.signUpButton.titleLabel?.font = UIFont(name: "NanumGothicOTFBold", size: 14)
    }
}
