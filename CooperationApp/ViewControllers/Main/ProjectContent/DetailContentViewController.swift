//
//  DetailContentViewController.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/06/09.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

//cell을 삭제하기 위한 index 값을 넘기는 delegate
protocol DeleteCellDelegate: AnyObject {
    func sendCellIndex(_ index: IndexPath)
}

//변경된 카드 내용 전달 delegate
protocol SendContentDelegate: AnyObject{
    func sendContent(_ name: String, _ index: Int, _ color: String, _ startTime: String, _ endTime: String)
}

// 시작 시간과 종료 시간을 선택할 때 변경
enum TimeSelectMode {
    case startTime
    case endTime
}

enum ShowColorDetailViewMode {
    case show
    case notShow
}

class DetailContentViewController: UIViewController {
    
    let db = Firestore.firestore() // firebase firestore
    var ref: DatabaseReference! = Database.database().reference() // firebase realtimeDB
    
    var detailColorContent = DetailColorContent()
    var projectDetailContent = ProjectDetailContent(cardName: "", color: "", startTime: "", endTime: "")
    
    var content: String = ""
    var id: String = ""
    var index = 0
    var cardColor = ""
    var timeSelectMode: TimeSelectMode = .startTime // 처음에 시작시간을 입력할수 있게 하기
    var showColorDetailViewMode: ShowColorDetailViewMode = .notShow // 처음에 color detail label 스택뷰는 안보이기
    var startTime: String = ""
    var endTime: String = ""
    weak var sendContentDelegate: SendContentDelegate?
    weak var sendCellIndexDelegate: DeleteCellDelegate?
    
    lazy var originConstraints = [
        dateStackView.topAnchor.constraint(equalTo: cardColorStackView.bottomAnchor, constant: 24),
    ]
    lazy var updatedConstraints = [
        dateStackView.topAnchor.constraint(equalTo: cardColorDetailStackView.bottomAnchor, constant: 24),
    ]
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var detailView: UIView!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var cardColorStackView: UIStackView!
    
    @IBOutlet weak var showDetailColorButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var orangeButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    
    @IBOutlet weak var cardColorDetailStackView: UIStackView!
    //detail Color Iamage
    @IBOutlet weak var detailBlueImage: UIButton!
    @IBOutlet weak var detailGreenImage: UIButton!
    @IBOutlet weak var detailOrangeImage: UIButton!
    @IBOutlet weak var detailPurpleImage: UIButton!
    @IBOutlet weak var detailYellowImage: UIButton!
    
    //detail color TextField
    @IBOutlet weak var detailBlueTextField: UITextField!
    @IBOutlet weak var detailGreenTextField: UITextField!
    @IBOutlet weak var detailOrangeTextField: UITextField!
    @IBOutlet weak var detailPurpleTextField: UITextField!
    @IBOutlet weak var detailYellowTextField: UITextField!
    
    @IBOutlet weak var dateStackView: UIStackView!
    @IBOutlet weak var startLabel: UILabel! // 달력에서 선택된 시작시간
    @IBOutlet weak var endLabel: UILabel! // 달력에서 선택된 종료시간
    @IBOutlet weak var startTimeLabel: UILabel! // 시작시간 Label
    @IBOutlet weak var endTimeLabel: UILabel! // 종료시간 Label
    
    @IBOutlet weak var startTimeStackView: UIStackView!
    @IBOutlet weak var endTimeStackView: UIStackView!
    
    @IBOutlet weak var buttonStackView: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let color = self.projectDetailContent.color else { return }
        self.changeCardColor(color: color)
        self.configureView()
        self.loadUserDefault()
        
        let tabStartTimeLabel = UITapGestureRecognizer(target: self, action: #selector(tabStartLabelSelector))
        let tabEndTimeLabel = UITapGestureRecognizer(target: self, action: #selector(tabEndLabelSelector))
        self.startTimeStackView.addGestureRecognizer(tabStartTimeLabel)
        self.endTimeStackView.addGestureRecognizer(tabEndTimeLabel)

    }
    //시작시간 stackview클릭시 발생
    @objc func tabStartLabelSelector(sender: UITapGestureRecognizer) {
        
        self.timeSelectMode = .startTime
        DispatchQueue.main.async {
            self.startLabel.font = UIFont.boldSystemFont(ofSize: 18)
            self.endLabel.font = UIFont.systemFont(ofSize: 17)
//            self.endTimeLabel.backgroundColor = .white
//            self.startTimeLabel.backgroundColor = .gray
        }
    }
    
    //종료시간 stackview클릭시 발생
    @objc func tabEndLabelSelector(sender: UITapGestureRecognizer) {
        
        self.timeSelectMode = .endTime
        DispatchQueue.main.async {
            self.endLabel.font = UIFont.boldSystemFont(ofSize: 18)
            self.startLabel.font = UIFont.systemFont(ofSize: 17)
//            self.endTimeLabel.backgroundColor = .gray
//            self.startTimeLabel.backgroundColor = .white
        }
    }
    
    @IBAction func showDetailColorStackView(_ sender: UIButton) {
        print("버튼이 클릭되었습니다.")
        UIView.animate(withDuration: 0.5, animations: {
            
            switch self.showColorDetailViewMode {
            case .show:
                self.scrollView.contentSize.height = 800
                self.detailView.frame.size.height = 800
                self.showDetailColorButton.setImage(UIImage(systemName: "plus"), for: .normal)
                self.cardColorDetailStackView.alpha = 0

                self.dateStackView.transform = CGAffineTransform(translationX: 0, y: -200)
                self.startTimeStackView.transform = CGAffineTransform(translationX: 0, y: -200)
                self.endTimeStackView.transform = CGAffineTransform(translationX: 0, y: -200)
                self.buttonStackView.transform = CGAffineTransform(translationX: 0, y: -200)

                self.showColorDetailViewMode = .notShow
                
            case .notShow:
                self.scrollView.contentSize.height = 1000
                self.detailView.frame.size.height = 1000
                self.showDetailColorButton.setImage(UIImage(systemName: "minus"), for: .normal)
                self.cardColorDetailStackView.alpha = 1

                self.dateStackView.transform = CGAffineTransform(translationX: 0, y: 0)
                self.startTimeStackView.transform = CGAffineTransform(translationX: 0, y: 0)
                self.endTimeStackView.transform = CGAffineTransform(translationX: 0, y: 0)
                self.buttonStackView.transform = CGAffineTransform(translationX: 0, y: 0)
                
                self.showColorDetailViewMode = .show
                
            }
        })
    }
    
    
    //카드 색 설정
    @IBAction func tabCardColorButton(_ sender: UIButton) {
        if sender == self.blueButton {
            self.cardColor = "blue"
            changeCardColor(color: "blue")
        } else if sender == self.greenButton {
            self.cardColor = "green"
            changeCardColor(color: "green")
        } else if sender == self.orangeButton {
            self.cardColor = "orange"
            changeCardColor(color: "orange")
        } else if sender == self.purpleButton {
            self.cardColor = "purple"
            changeCardColor(color: "purple")
        } else {
            self.cardColor = "yellow"
            changeCardColor(color: "yellow")
        }
    }
    
    //카드 색 alpha값 조정
    private func changeCardColor(color: String){
        self.blueButton.alpha = color == "blue" ? 1 : 0.2
        self.greenButton.alpha = color == "green" ? 1 : 0.2
        self.orangeButton.alpha = color == "orange" ? 1 : 0.2
        self.purpleButton.alpha = color == "purple" ? 1 : 0.2
        self.yellowButton.alpha = color == "yellow" ? 1 : 0.2
    }
    
    //detailColorContent 변경하기
    @IBAction func changeDetailColorContent(_ sender: UIButton) {
        
        let userDefaults = UserDefaults.standard
        let encoder = JSONEncoder()
        
        let blueContent = self.detailBlueTextField.text ?? ""
        let greenContent = self.detailGreenTextField.text ?? ""
        let orangeContent = self.detailOrangeTextField.text ?? ""
        let purpleContent = self.detailPurpleTextField.text ?? ""
        let yellowContent = self.detailYellowTextField.text ?? ""
        
        let colorContent = DetailColorContent(blueContent: blueContent, greenContent: greenContent, orangeContent: orangeContent, purpleContent: purpleContent, yellowContent: yellowContent)
        
        let colorContentEncoder = try? encoder.encode(colorContent)
        
        userDefaults.set(colorContentEncoder, forKey: "detailColorContent")
        print("변경되었다")
    }
    
    //userDefault 불러오기
    func loadUserDefault() {
        let userDefaults = UserDefaults.standard
        let decoder = JSONDecoder()
        guard let data = userDefaults.object(forKey: "detailColorContent") else { return }
        
        let colorContentDecoder = try? decoder.decode(DetailColorContent.self, from: data as! Data)
        
        self.detailBlueTextField.text =  colorContentDecoder?.blueContent
        self.detailGreenTextField.text = colorContentDecoder?.greenContent
        self.detailOrangeTextField.text = colorContentDecoder?.orangeContent
        self.detailPurpleTextField.text = colorContentDecoder?.purpleContent
        self.detailYellowTextField.text = colorContentDecoder?.yellowContent
    }
    
    //날짜 정하기 설정
    @IBAction func UIDatePicker(_ sender: UIDatePicker) {
        let datePickerView = sender
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        switch self.timeSelectMode {
        case .startTime:
            startTimeLabel.text = formatter.string(from: datePickerView.date)
        default:
            endTimeLabel.text = formatter.string(from: datePickerView.date)
        }
    }

    // 화면 구성
    func configureView() {
        
        if let color = self.projectDetailContent.color {
            self.cardColor = color
        }
        
        DispatchQueue.main.async {
            
            self.contentTextView.text = self.projectDetailContent.cardName
            self.startTimeLabel.text = self.projectDetailContent.startTime
            self.endTimeLabel.text = self.projectDetailContent.endTime
            self.contentTextView.translatesAutoresizingMaskIntoConstraints = false //
            
            self.scrollView.contentSize.height = 800
            self.detailView.bounds.size.height = 800
            
            self.detailBlueImage.layer.cornerRadius = 10
            self.detailGreenImage.layer.cornerRadius = 10
            self.detailOrangeImage.layer.cornerRadius = 10
            self.detailPurpleImage.layer.cornerRadius = 10
            self.detailYellowImage.layer.cornerRadius = 10
            
            self.cardColorDetailStackView.alpha = 0
            
            self.dateStackView.transform = CGAffineTransform(translationX: 0, y: -200)
            self.startTimeStackView.transform = CGAffineTransform(translationX: 0, y: -200)
            self.endTimeStackView.transform = CGAffineTransform(translationX: 0, y: -200)
            self.buttonStackView.transform = CGAffineTransform(translationX: 0, y: -200)
        }
    }
    
    // cell 안에 내용 수정
    @IBAction func fixButton(_ sender: UIButton) {
        self.sendContentDelegate?.sendContent(contentTextView.text, index, self.cardColor, startTimeLabel.text!, endTimeLabel.text!)
        self.dismiss(animated: true)
    }
    
    @IBAction func deleteCell(_ sender: UIButton) {
        self.sendCellIndexDelegate?.sendCellIndex([0, self.index])
        self.dismiss(animated: true)
    }
    
    
    @IBAction func cancelButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}
