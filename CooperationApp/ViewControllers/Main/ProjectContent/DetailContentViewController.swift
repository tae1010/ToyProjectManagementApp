//
//  DetailContentViewController.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/06/09.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

//cell을 삭제하기 위한 index 값을 넘기는 delegate
protocol DeleteCellDelegate: AnyObject {
    func sendCellIndex(_ index: IndexPath)
}

//변경된 카드 내용 전달 delegate
protocol SendContentDelegate: AnyObject{
    func sendContent(_ name: String, _ index: Int, _ color: String, _ startTime: String, _ endTime: String)
}

enum TimeSelectMode {
    case startTime
    case endTime
}

class DetailContentViewController: UIViewController {
    
    var ref: DatabaseReference! = Database.database().reference()
    var content: String = ""
    var id: String = ""
    var index = 0
    var cardColor = ""
    var timeSelectMode: TimeSelectMode = .startTime
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
    
    @IBOutlet weak var detailView: UIView!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var cardColorStackView: UIStackView!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var orangeButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    
    @IBOutlet weak var cardColorDetailStackView: UIStackView!
    @IBOutlet weak var detailBlueImage: UIButton!
    @IBOutlet weak var detailGreenImage: UIButton!
    @IBOutlet weak var detailOrangeImage: UIButton!
    @IBOutlet weak var detailPurpleImage: UIButton!
    @IBOutlet weak var detailYellowImage: UIButton!
    
    @IBOutlet weak var dateStackView: UIStackView!
    @IBOutlet weak var startLabel: UILabel! // 달력에서 선택된 시작시간
    @IBOutlet weak var endLabel: UILabel! // 달력에서 선택된 종료시간
    @IBOutlet weak var startTimeLabel: UILabel! // 시작시간 Label
    @IBOutlet weak var endTimeLabel: UILabel! // 종료시간 Label
    
    @IBOutlet weak var startTimeStackView: UIStackView!
    @IBOutlet weak var endTimeStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeCardColor(color: cardColor)

        self.configureView()
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
        
        DispatchQueue.main.async {
            self.cardColorDetailStackView.isHidden = false
            self.cardColorDetailStackView.translatesAutoresizingMaskIntoConstraints = false
            self.dateStackView.translatesAutoresizingMaskIntoConstraints = false
            
            self.dateStackView.topAnchor.constraint(equalTo: self.cardColorDetailStackView.bottomAnchor, constant: 24.0).isActive = true
            self.dateStackView.trailingAnchor.constraint(equalTo: self.detailView.trailingAnchor, constant: 24.0).isActive = true
            self.dateStackView.leadingAnchor.constraint(equalTo: self.detailView.leadingAnchor, constant: 24.0).isActive = true

        }

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
        self.contentTextView.text = content
        self.startTimeLabel.text = startTime
        self.endTimeLabel.text = endTime
        self.contentTextView.translatesAutoresizingMaskIntoConstraints = false //
        
        self.detailBlueImage.layer.cornerRadius = 10
        self.detailGreenImage.layer.cornerRadius = 10
        self.detailOrangeImage.layer.cornerRadius = 10
        self.detailPurpleImage.layer.cornerRadius = 10
        self.detailYellowImage.layer.cornerRadius = 10
        
        self.cardColorDetailStackView.isHidden = true
        self.cardColorDetailStackView.translatesAutoresizingMaskIntoConstraints = false
        self.dateStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.dateStackView.topAnchor.constraint(equalTo: cardColorStackView.bottomAnchor, constant: 24.0).isActive = true
        self.dateStackView.trailingAnchor.constraint(equalTo: self.detailView.trailingAnchor, constant: 24.0).isActive = true
        self.dateStackView.leadingAnchor.constraint(equalTo: self.detailView.leadingAnchor, constant: 24.0).isActive = true
    
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
