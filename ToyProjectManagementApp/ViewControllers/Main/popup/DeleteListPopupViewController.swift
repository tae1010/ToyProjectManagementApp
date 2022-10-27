//
//  DeleteListPopupViewController.swift
//  ToyProjectManagementApp
//
//  Created by 김정태 on 2022/10/25.
//

import Foundation
import UIKit

protocol DeleteListDelegate: AnyObject {
    func deleteListDelegate(index: IndexPath)
}

class DeleteListPopupViewController: UIViewController {
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var listDeleteButton: UIButton!
    
    
    weak var deleteListDelegate: DeleteListDelegate?
    
    var index: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    @IBAction func tapDeleteListButton(_ sender: UIButton) {
        guard let index = self.index else { return }
        self.deleteListDelegate?.deleteListDelegate(index: index)
        self.dismiss(animated: true)
    }
    
    
    @IBAction func tapCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}

// MARK: - configure
extension DeleteListPopupViewController {
    
    private func configure() {
        self.configurePopupView()
        self.configureAddCardButton()
        self.configureAddListButton()
    }
    
    private func configurePopupView() {
        self.popupView.layer.cornerRadius = 8
    }
    
    private func configureAddCardButton() {
        self.cancelButton.titleLabel?.font = UIFont(name: "NanumGothicOTF", size: 14)
    }
    
    private func configureAddListButton() {
        self.listDeleteButton.titleLabel?.font = UIFont(name: "NanumGothicOTF", size: 14)
    }
}
