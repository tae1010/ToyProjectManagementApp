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
    
    var projectDetailContent = ProjectDetailContent(cardName: "", color: "", startTime: "", endTime: "")
    
    let detailCGColor: [CGColor] = [UIColor.color0CGColor, UIColor.color1CGColor, UIColor.color2CGColor, UIColor.color3CGColor, UIColor.color4CGColor, UIColor.color5CGColor, UIColor.color6CGColor, UIColor.color7CGColor, UIColor.color8CGColor, UIColor.color9CGColor, UIColor.color10CGColor, UIColor.color11CGColor, UIColor.color12CGColor, UIColor.color13CGColor, UIColor.color14CGColor, UIColor.color15CGColor]
    
    let detailUIColor: [UIColor?] = [UIColor.color0, UIColor.color1, UIColor.color2, UIColor.color3, UIColor.color4, UIColor.color5, UIColor.color6, UIColor.color7, UIColor.color8, UIColor.color9, UIColor.color10, UIColor.color11, UIColor.color12, UIColor.color13, UIColor.color14, UIColor.color15]
    
    var content: String = "" // card 내용
    var id: String = "" // project id
    var index = 0
    var cardColor: UIColor = .white
    var cardColorString = "" // "color\(index)"
    var colorContent = [String](repeating: "", count: 16) // color content값들이 들어있는 16칸 배열
    var email = ""
    
    var timeSelectMode: TimeSelectMode = .startTime // 처음에 시작시간을 입력할수 있게 하기
    var showColorDetailViewMode: ShowColorDetailViewMode = .notShow // 처음에 color detail label 스택뷰는 안보이기
    var startTime: String = ""
    var endTime: String = ""
    
    weak var sendContentDelegate: SendContentDelegate?
    weak var sendCellIndexDelegate: DeleteCellDelegate?
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var cardTitleLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var cardColorLabel: UILabel!
    @IBOutlet weak var showDetailColorButton: UIButton!
    
    @IBOutlet weak var deleteCardColorButton: UIButton!
    @IBOutlet weak var cardBackgroundColorView: UIView!
    @IBOutlet weak var cardColorView: UIView!
    @IBOutlet weak var cardColorContentLabel: UILabel!
    
    @IBOutlet weak var detailColorCollectionView: UICollectionView!
    
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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround() // 화면 클릭시 키보드 내림
        self.configure()
        
        let tabStartTimeLabel = UITapGestureRecognizer(target: self, action: #selector(tabStartLabelSelector))
        let tabEndTimeLabel = UITapGestureRecognizer(target: self, action: #selector(tabEndLabelSelector))
        
        self.startTimeStackView.addGestureRecognizer(tabStartTimeLabel)
        self.endTimeStackView.addGestureRecognizer(tabEndTimeLabel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.readDB()
        
    }
    
    
    @IBAction func tapDeleteCardColorButton(_ sender: UIButton) {
        self.cardColorString = ""
        self.cardColor = .white
        self.cardColorContentLabel.text = ""
        
        self.changeColor()
    }
    
    @IBAction func showDetailColorStackView(_ sender: UIButton) {
        print("버튼이 클릭되었습니다.")
        
        switch self.showColorDetailViewMode {
        case .notShow:
            
            self.dateStackViewTopAnchor.constant = 236
            
            UIView.animate(withDuration: 0.5, animations: {
                self.detailColorCollectionView.alpha = 1
                self.deleteCardColorButton.alpha = 1
//                self.deleteCardColorButton.isHidden = false
                self.view.layoutIfNeeded()
            })
            
            self.showDetailColorButton.setImage(UIImage(systemName: "minus"), for: .normal)
            
            self.showColorDetailViewMode = .show
            
        case .show:
            self.dateStackViewTopAnchor.constant = 32
            
            UIView.animate(withDuration: 0.5, animations: {
                self.detailColorCollectionView.alpha = 0
                self.deleteCardColorButton.alpha = 0
//                self.deleteCardColorButton.isHidden = true
                self.view.layoutIfNeeded()
            })
            
            self.showDetailColorButton.setImage(UIImage(systemName: "plus"), for: .normal)
            
            self.showColorDetailViewMode = .notShow
        }
        
        self.detailColorCollectionView.reloadData()
        
    }
    
    //날짜 정하기 설정
    @IBAction func UIDatePicker(_ sender: UIDatePicker) {
        let datePickerView = sender
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        switch self.timeSelectMode {
            
        case .startTime:
            if endTimeLabel.text != "" && endTimeLabel.text! < formatter.string(from: datePickerView.date) {
                self.view.hideAllToasts()
                self.view.makeToast("시작 시간이 종료 시간보다 작아야 합니다.")
                return
            } else {
                startTimeLabel.text = formatter.string(from: datePickerView.date)
            }

        default:
            if startTimeLabel.text != "" && startTimeLabel.text! > formatter.string(from: datePickerView.date) {
                self.view.hideAllToasts()
                self.view.makeToast("종료 시간이 시작 시간보다 커야 합니다.")
                return
            } else {
                endTimeLabel.text = formatter.string(from: datePickerView.date)
            }
        }
    }
    
    // cell 안에 내용 수정
    @IBAction func fixButton(_ sender: UIButton) {
        self.sendContentDelegate?.sendContent(contentTextView.text, index, self.cardColorString, startTimeLabel.text ?? "", endTimeLabel.text ?? "")
        self.dismiss(animated: true)
    }
    
    @IBAction func deleteCell(_ sender: UIButton) {
        self.sendCellIndexDelegate?.sendCellIndex([self.index, 0])
        self.dismiss(animated: true)
    }
    
    
    @IBAction func cancelButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}

// MARK: - configure
extension DetailContentViewController {

    private func configure() {
        self.configureCardTitle()
        self.configureChooseDate()
        self.configureButton()
        self.configureDetailColorCollectionView()
        self.configureDate()
        self.configureCardColor()
    }

    private func configureCardTitle() {
        self.cardTitleLabel.font = UIFont(name: "NanumGothicOTFBold", size: 14)
        self.contentTextView.font = UIFont(name: "NanumGothicOTFBold", size: 15)
    }
    
    private func configureCardColor() {
        
        self.cardColorLabel.font = UIFont(name: "NanumGothicOTFBold", size: 14)
        self.cardColorView.layer.cornerRadius = self.cardColorView.frame.width / 2
        
        self.cardColorView.layer.borderWidth = 1
        self.cardColorView.layer.borderColor = UIColor.white.cgColor

        self.cardBackgroundColorView.layer.cornerRadius = 8
        
        self.cardBackgroundColorView.layer.borderWidth = 1
        self.cardBackgroundColorView.layer.borderColor = UIColor.gray.cgColor
        
        self.cardColorContentLabel.font = UIFont(name: "NanumGothicOTFBold", size: 14)
        self.cardColorContentLabel.textColor = self.cardColor.isLight() ? .black : .white

    }
    
    private func configureCardColorData() {

        if let cardColor = self.projectDetailContent.color {
            self.cardColorString = cardColor
            // db에 저장되어 있는 color(String)값을 UIColor로 변환후 몇번째 배열인지 찾음
            let color = Color(rawValue: cardColor)
            let colorSelected = color?.create // color UIColor로 변환
            let currentColorIndex = detailUIColor.firstIndex(of: colorSelected) ?? 0
            
            // cardColor에 맞게 text값과 배경색을 지정
            self.cardColor = colorSelected ?? .white // UIColor를 cardColor에 저장
            self.cardColorView.backgroundColor = self.cardColor
            self.cardBackgroundColorView.backgroundColor = self.cardColor
            
            if self.cardColor == UIColor.white {
                self.cardBackgroundColorView.layer.borderColor = UIColor.gray.cgColor
            } else {
                self.cardBackgroundColorView.layer.borderColor = self.cardColor.cgColor
            }
            
            self.cardColorLabel.font = UIFont(name: "NanumGothicOTFBold", size: 14)
            self.cardColorContentLabel.text = self.colorContent[currentColorIndex]
            
        }
    }
    
    private func configureChooseDate() {
        self.chooseDateLabel.font = UIFont(name: "NanumGothicOTFBold", size: 14)
    }
    
    private func configureDate() {
        self.startLabel.font = UIFont(name: "NanumGothicOTFBold", size: 14)
        self.endLabel.font = UIFont(name: "NanumGothicOTFLight", size: 14)
        
        self.startTimeLabel.font = UIFont(name: "NanumGothicOTF", size: 15)
        self.endTimeLabel.font = UIFont(name: "NanumGothicOTF", size: 15)
        
    }
    
    private func configureButton() {
        
        self.cardFixButton.titleLabel?.font = UIFont(name: "NanumGothicOTF", size: 14)
        self.cardDeleteButton.titleLabel?.font = UIFont(name: "NanumGothicOTF", size: 14)
        self.cardCancelButton.titleLabel?.font = UIFont(name: "NanumGothicOTF", size: 14)
        
        self.cardFixButton.layer.cornerRadius = 8
        self.cardDeleteButton.layer.cornerRadius = 8
        self.cardCancelButton.layer.cornerRadius = 8

    }
    
    private func configureDetailColorCollectionView() {
        self.detailColorCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.detailColorCollectionView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        self.detailColorCollectionView.delegate = self
        self.detailColorCollectionView.dataSource = self
    }
    
    private func changeColor() {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.cardColorView.backgroundColor = self.cardColor
            self.cardBackgroundColorView.backgroundColor = self.cardColor
            
            if self.cardColor == UIColor.white {
                print(self.cardColor, "z")
                self.cardBackgroundColorView.layer.borderColor = UIColor.gray.cgColor
            } else {
                print(self.cardColor, "x")
                self.cardBackgroundColorView.layer.borderColor = self.cardColor.cgColor
            }
            
            self.cardColorContentLabel.textColor = self.cardColor.isLight() ? .black : .white
        })
        
    }
}


// MARK: - selector
extension DetailContentViewController {
    
    //시작시간 stackview클릭시 발생
    @objc func tabStartLabelSelector(sender: UITapGestureRecognizer) {
        
        self.timeSelectMode = .startTime
        DispatchQueue.main.async {
            self.startLabel.font = UIFont(name: "NanumGothicOTFBold", size: 14)
            self.endLabel.font = UIFont(name: "NanumGothicOTFLight", size: 14)
        }
    }
    
    //종료시간 stackview클릭시 발생
    @objc func tabEndLabelSelector(sender: UITapGestureRecognizer) {
        
        self.timeSelectMode = .endTime
        DispatchQueue.main.async {
            self.endLabel.font = UIFont(name: "NanumGothicOTFBold", size: 14)
            self.startLabel.font = UIFont(name: "NanumGothicOTFLight", size: 14)
        }
    }
}

// MARK: - CardColor CollectionView
extension DetailContentViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.cardColorString = "color\(indexPath.row)"
        self.cardColor = detailUIColor[indexPath.row] ?? .white
        self.cardColorContentLabel.text = self.colorContent[indexPath.row]
        
        self.changeColor()
    }
}

extension DetailContentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailUIColor.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailContentColorCell", for: indexPath) as? DetailContentColorCell else { return UICollectionViewCell() }
    
        cell.contentView.layer.backgroundColor = detailCGColor[indexPath.row]

        return cell
    }
}

extension DetailContentViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (UIScreen.main.bounds.width / 4) - 30
        let height = width / 2
        
        return CGSize(width: width, height: height)
    }
}

extension DetailContentViewController {
    
    private func readDB() {
        hideViews()
        print(#fileID, #function, #line, "- ProjectColorContentViewController readDB실행")
        self.colorContent.removeAll()
        print(email, id)
        
        ref.child("\(email)/\(id)/colorContent").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [String?] else {
                self.showViews()
                return
            }
            
            var colors = [String]()
            for i in value {
                guard let color = i else { return }
                colors.append(color)
            }

            self.colorContent = colors
            print(self.colorContent, "가낟")
            
            DispatchQueue.main.async {
                self.contentTextView.text = self.projectDetailContent.cardName
                self.startTimeLabel.text = self.projectDetailContent.startTime
                self.endTimeLabel.text = self.projectDetailContent.endTime
                self.configureCardColor()
                self.showViews()
                self.configureCardColorData()
            }
            
        }) { error in
            print(error.localizedDescription)
            self.showViews()
        }
    }
}


// MARK: - indicator
extension DetailContentViewController {
    
    private func hideViews() {
        self.contentView.alpha = 0
        
        self.activityIndicator.alpha = 1
        self.activityIndicator.startAnimating()
    }
    
    private func showViews() {
        UIView.animate(
            withDuration: 0.7,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .curveEaseOut,
            animations: {
                self.activityIndicator.alpha = 0
                self.contentView.alpha = 1
        }, completion: { _ in
            self.activityIndicator.stopAnimating()
        })
    }

}


// MARK: - scrollview

extension DetailContentViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.bounces = scrollView.contentOffset.y > 0
    }
    
}

