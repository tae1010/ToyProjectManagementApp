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
    func sendContent(_ name: String, _ index: Int, _ startTime: String, _ endTime: String)
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
    var timeSelectMode: TimeSelectMode = .startTime
    var startTime: String = ""
    var endTime: String = ""
    weak var delegate: SendContentDelegate?
    
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var startLabel: UILabel! // 달력에서 선택된 시작시간
    @IBOutlet weak var endLabel: UILabel! // 달력에서 선택된 종료시간
    @IBOutlet weak var startTimeLabel: UILabel! // 시작시간 Label
    @IBOutlet weak var endTimeLabel: UILabel! // 종료시간 Label
    @IBOutlet weak var startTimeStackView: UIStackView!
    @IBOutlet weak var endTimeStackView: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    }
    
    // cell 안에 내용 수정
    @IBAction func fixButton(_ sender: UIButton) {
        self.delegate?.sendContent(contentTextView.text, index, startTimeLabel.text!, endTimeLabel.text!)
        self.dismiss(animated: true)
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}
