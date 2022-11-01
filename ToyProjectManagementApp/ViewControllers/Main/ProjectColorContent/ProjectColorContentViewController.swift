//
//  ProjectColorContentViewController.swift
//  ToyProjectManagementApp
//
//  Created by 김정태 on 2022/11/01.
//

import Foundation
import UIKit

class ProjectColorContentViewController: UIViewController {
    
    @IBOutlet weak var labelManagement: UILabel!
    @IBOutlet weak var cardLabelContentCollectionView: UICollectionView!
    @IBOutlet weak var cardContentTextField: UITextField!
    
    @IBOutlet weak var removeColorButton: UIButton!
    @IBOutlet weak var changeColorContentbutton: UIButton!
    
    var currentStringColor: Int?
    var colorContent = [String](repeating: "", count: 16)
    
    let detailCGColor: [CGColor] = [UIColor.color0CGColor, UIColor.color1CGColor, UIColor.color2CGColor, UIColor.color3CGColor, UIColor.color4CGColor, UIColor.color5CGColor, UIColor.color6CGColor, UIColor.color7CGColor, UIColor.color8CGColor, UIColor.color9CGColor, UIColor.color10CGColor, UIColor.color11CGColor, UIColor.color12CGColor, UIColor.color13CGColor, UIColor.color14CGColor, UIColor.color15CGColor]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround() // 화면 클릭시 키보드 내림
        self.configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.colorContent = UserDefault().loadUserdefault()
        print(colorContent)
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func tabRemoveColorButton(_ sender: UIButton) {
        
        self.currentStringColor = nil
        
        self.cardContentTextField.layer.cornerRadius = 8.0
        self.cardContentTextField.layer.borderWidth = 1
        self.cardContentTextField.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
    }
    
    @IBAction func tabChangeColorContentbutton(_ sender: UIButton) {
        
        guard let currentColor = self.currentStringColor else {
            self.view.makeToast("라벨 색을 선택해 주세요", duration: 0.5)
            return
        }
        
        guard let cardContentText = self.cardContentTextField.text else {
            self.view.makeToast("라벨 내용을 적어 주세요", duration: 0.5)
            return
        }
        
        self.colorContent[currentColor] = cardContentText
        
        UserDefault().saveColorContentUserdefault(colorContent: self.colorContent)
    }
    
}

extension ProjectColorContentViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.currentStringColor = indexPath.row
        
        self.cardContentTextField.layer.cornerRadius = 8.0
        self.cardContentTextField.layer.borderWidth = 3
        self.cardContentTextField.layer.borderColor = detailCGColor[indexPath.row]
        
        self.cardContentTextField.text = self.colorContent[indexPath.row]
        
    }
}

extension ProjectColorContentViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailCGColor.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailContentColorCell", for: indexPath) as? DetailContentColorCell else { return UICollectionViewCell() }
        
//        cell.backgroundColor = detailUIColor[indexPath.row]
        cell.contentView.layer.backgroundColor = detailCGColor[indexPath.row]

        return cell
    }

}

extension ProjectColorContentViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (UIScreen.main.bounds.width / 4) - 30
        let height = width / 2
        
        return CGSize(width: width, height: height)
    }
}


// MARK: - configure
extension ProjectColorContentViewController {
    
    private func configure() {
        self.configureDetailColorCollectionView()
        self.configureTitleLabel()
        self.configureCardContentTextField()
        self.configureRemoveColorButton()
        self.configureChangeColorContentbutton()
    }
    
    private func configureDetailColorCollectionView() {
        self.cardLabelContentCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.cardLabelContentCollectionView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        self.cardLabelContentCollectionView.delegate = self
        self.cardLabelContentCollectionView.dataSource = self
    }
    
    private func configureTitleLabel() {
        self.labelManagement.font = UIFont(name: "NanumGothicOTFBold", size: 28)
    }

    // 기본 textfield
    private func configureCardContentTextField() {
        self.cardContentTextField.borderStyle = .none
        self.cardContentTextField.layer.cornerRadius = 8.0
        self.cardContentTextField.layer.borderWidth = 1
        self.cardContentTextField.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor // border color
        
        // textfield leftview
        self.cardContentTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.cardContentTextField.frame.height))
        self.cardContentTextField.leftViewMode = .always
        self.cardContentTextField.autocorrectionType = .no
        
        // text color
        self.cardContentTextField.textColor = UIColor.gray
        self.cardContentTextField.font = UIFont(name: "NanumGothicOTF", size: 14)
        self.cardContentTextField.textColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1) // text color
        
        
        // placeholder font, color
        self.cardContentTextField.attributedPlaceholder = NSAttributedString(string: "라벨 내용을 적어주세요", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)]) // placeholder color
    }
    
    private func configureRemoveColorButton() {
        self.removeColorButton.layer.cornerRadius = 8
        self.removeColorButton.titleLabel?.font = UIFont(name: "NanumGothicOTF", size: 15)
    }
    
    private func configureChangeColorContentbutton() {
        self.changeColorContentbutton.layer.cornerRadius = 8
        self.changeColorContentbutton.titleLabel?.font = UIFont(name: "NanumGothicOTF", size: 15)
    }
}
