//
//  CustomTextField.swift
//  ToyProjectManagementApp
//
//  Created by 김정태 on 2022/09/18.
//

import UIKit

class CustomTextField: UITextField {
    
    var textFieldPlaceholder: String = "값을 입력해주세요."

    convenience init(textFieldPlaceholder: String) {
        self.init()
        self.textFieldPlaceholder = textFieldPlaceholder
        self.initializeTextField(textFieldPlaceholder: textFieldPlaceholder)
    }

    override func draw(_ rect: CGRect) {
        // Drawing code
        self.initializeTextField(textFieldPlaceholder: textFieldPlaceholder)
    }

    private func initializeTextField(textFieldPlaceholder: String) {
        
        self.delegate = self
        
        self.translatesAutoresizingMaskIntoConstraints = false

        self.borderStyle = .none
        self.layer.cornerRadius = 8.0
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor // border color
        
        self.textColor = UIColor.gray
        self.font = UIFont(name: "NanumGothicOTF", size: 14)
        self.textColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1) // text color
        
        self.attributedPlaceholder = NSAttributedString(string: textFieldPlaceholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)]) // placeholder color

        
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.height))
        self.leftViewMode = .always
    }

}

// MARK: - textfield click delegate
extension CustomTextField: UITextFieldDelegate {
    
    // textview click
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textfield 선택")
        textField.becomeFirstResponder()
        textField.layer.borderColor = UIColor.primaryCGColor
        textField.tintColor = UIColor.primaryColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
    }
}
