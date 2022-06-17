//
//  DetailContentViewController.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/06/09.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

protocol SendContentDelegate: AnyObject{
    func sendContent(_ name: String, _ index: Int)
}

class DetailContentViewController: UIViewController {

    @IBOutlet weak var contentTextView: UITextView!
    var ref: DatabaseReference! = Database.database().reference()
    var content: String = ""
    var id: String = ""
    var index = 0
    weak var delegate: SendContentDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    // 화면 구성
    func configureView() {
        self.contentTextView.text = content
        self.contentTextView.translatesAutoresizingMaskIntoConstraints = false //
    }
    
    // cell 안에 내용 수정
    @IBAction func fixButton(_ sender: UIButton) {
        self.delegate?.sendContent(contentTextView.text, index)
        self.dismiss(animated: true)
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}
