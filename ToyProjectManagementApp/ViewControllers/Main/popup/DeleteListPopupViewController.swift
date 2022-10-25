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
    
    weak var deleteListDelegate: DeleteListDelegate?
    
    var index: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
