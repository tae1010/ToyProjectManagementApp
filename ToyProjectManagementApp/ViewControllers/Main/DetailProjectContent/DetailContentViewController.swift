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

// 변경된 카드 내용 전달 delegate
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
    
    @IBOutlet weak var cardTitleLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var cardColorLabel: UILabel!
    @IBOutlet weak var showDetailColorButton: UIButton!
    
    @IBOutlet weak var cardColorView: UIView!
    @IBOutlet weak var cardColorContentLabel: UILabel!
    
    @IBOutlet weak var detailColorView: DetailColorView!
    
    @IBOutlet weak var chooseDateLabel: UILabel!
    @IBOutlet weak var dateStackViewTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var dateStackView: UIStackView!
    
    @IBOutlet weak var startLabel: UILabel! // 달력에서 선택된 시작시간
    @IBOutlet weak var endLabel: UILabel! // 달력에서 선택된 종료시간
    @IBOutlet weak var startTimeLabel: UILabel! // 시작시간 Label
    @IBOutlet weak var endTimeLabel: UILabel! // 종료시간 Label
    
    @IBOutlet weak var startTimeStackView: UIStackView!
    @IBOutlet weak var endTimeStackView: UIStackView!
    
    @IBOutlet weak var cardFixButton: UIButton!
    @IBOutlet weak var cardDeleteButton: UIButton!
    @IBOutlet weak var cardCancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        guard let color = self.projectDetailContent.color else { return }
        self.changeCardColor(color: color)
//        self.configureView()
        self.loadUserDefault()
        
        let tabStartTimeLabel = UITapGestureRecognizer(target: self, action: #selector(tabStartLabelSelector))
        let tabEndTimeLabel = UITapGestureRecognizer(target: self, action: #selector(tabEndLabelSelector))
        self.startTimeStackView.addGestureRecognizer(tabStartTimeLabel)
        self.endTimeStackView.addGestureRecognizer(tabEndTimeLabel)

    }
    

    
    @IBAction func showDetailColorStackView(_ sender: UIButton) {
        print("버튼이 클릭되었습니다.")
        
        switch self.showColorDetailViewMode {
        case .show:
    
            self.dateStackViewTopAnchor.constant = 388
            
            UIView.animate(withDuration: 0.5, animations: {
                self.detailColorView.alpha = 1
                self.view.layoutIfNeeded()
            })
            
            self.showDetailColorButton.setImage(UIImage(systemName: "plus"), for: .normal)
            self.showColorDetailViewMode = .notShow
            
        case .notShow:
            
            
            self.dateStackViewTopAnchor.constant = 24
            
            
            UIView.animate(withDuration: 0.5, animations: {
                self.detailColorView.alpha = 0
                self.view.layoutIfNeeded()
            })
            
            self.showDetailColorButton.setImage(UIImage(systemName: "minus"), for: .normal)
            self.showColorDetailViewMode = .show
        }
        
        

    }
    
    
//    //카드 색 설정
//    @IBAction func tabCardColorButton(_ sender: UIButton) {
//        if sender == self.blueButton {
//            self.cardColor = "blue"
//            changeCardColor(color: "blue")
//        } else if sender == self.greenButton {
//            self.cardColor = "green"
//            changeCardColor(color: "green")
//        } else if sender == self.orangeButton {
//            self.cardColor = "orange"
//            changeCardColor(color: "orange")
//        } else if sender == self.purpleButton {
//            self.cardColor = "purple"
//            changeCardColor(color: "purple")
//        } else {
//            self.cardColor = "yellow"
//            changeCardColor(color: "yellow")
//        }
//    }
    
    //카드 색 alpha값 조정
    private func changeCardColor(color: String){
//        self.blueButton.alpha = color == "blue" ? 1 : 0.2
    }

    //userDefault 불러오기
    func loadUserDefault() {
        let userDefaults = UserDefaults.standard
        let decoder = JSONDecoder()
        guard let data = userDefaults.object(forKey: "detailColorContent") else { return }
        
        let colorContentDecoder = try? decoder.decode(DetailColorContent.self, from: data as! Data)
    
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

// MARK: - configure
extension DetailContentViewController {
    

//@IBOutlet weak var cardColorView: UIView!
//@IBOutlet weak var cardColorContentLabel: UILabel!
//@IBOutlet weak var detailColorView: DetailColorView!

//@IBOutlet weak var chooseDateLabel: UILabel!
//@IBOutlet weak var dateStackViewTopAnchor: NSLayoutConstraint!
//@IBOutlet weak var dateStackView: UIStackView!
//
//@IBOutlet weak var startLabel: UILabel! // 달력에서 선택된 시작시간
//@IBOutlet weak var endLabel: UILabel! // 달력에서 선택된 종료시간
//@IBOutlet weak var startTimeLabel: UILabel! // 시작시간 Label
//@IBOutlet weak var endTimeLabel: UILabel! // 종료시간 Label
//
//@IBOutlet weak var startTimeStackView: UIStackView!
//@IBOutlet weak var endTimeStackView: UIStackView!
//
//@IBOutlet weak var cardFixButton: UIButton!
//@IBOutlet weak var cardDeleteButton: UIButton!
//@IBOutlet weak var cardCancelButton: UIButton!
    
    private func configure() {
        self.configureView()
        self.configureCardColor()
        self.configureCardTitle()
        self.configureChooseDate()
        self.configureDate()
        self.configureButton()
    }
    
    // 화면 구성
    func configureView() {
        
        if let color = self.projectDetailContent.color {
            self.cardColor = color
        }

        self.contentTextView.text = self.projectDetailContent.cardName
        self.startTimeLabel.text = self.projectDetailContent.startTime
        self.endTimeLabel.text = self.projectDetailContent.endTime
    }
    
    private func configureCardTitle() {
        self.cardTitleLabel.font = UIFont(name: "NanumGothicOTFExtraBold", size: 16)
        self.contentTextView.font = UIFont(name: "NanumGothicOTFBold", size: 14)
    }
    
    private func configureCardColor() {
        self.cardColorLabel.font = UIFont(name: "NanumGothicOTFExtraBold", size: 16)
        
    }
    
    private func configureChooseDate() {
        self.chooseDateLabel.font = UIFont(name: "NanumGothicOTFExtraBold", size: 16)
    }
    
    private func configureDate() {
        self.startLabel.font = UIFont(name: "NanumGothicOTFExtraBold", size: 16)
        self.endLabel.font = UIFont(name: "NanumGothicOTFExtraBold", size: 16)
        
        self.startTimeLabel.font = UIFont(name: "NanumGothicOTF", size: 14)
        self.endTimeLabel.font = UIFont(name: "NanumGothicOTF", size: 14)
    }
    
    private func configureButton() {
        self.cardFixButton.titleLabel?.font = UIFont(name: "NanumGothicOTF", size: 14)
        self.cardDeleteButton.titleLabel?.font = UIFont(name: "NanumGothicOTF", size: 14)
        self.cardCancelButton.titleLabel?.font = UIFont(name: "NanumGothicOTF", size: 14)
    }
    
}


// MARK: - selector
extension DetailContentViewController {
    
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
}
