//
//  ProjectViewController.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/05/11.
//

// 바꾼거 tableview ->  collectionview , datasource delegate collectionview로 바꿔줌
import UIKit
import FirebaseAuth
import FirebaseDatabase
import SideMenu
import MaterialComponents.MaterialBottomSheet
import Toast_Swift

// cell편집모드(cell 내용 수정, cell 양옆(다른 currentPage로 이동))
enum Mode {
    case edit
    case normal
}

class ProjectContentViewController: UIViewController {
    
    var mode: Mode = .normal // 평상시 상태는 edit상태가 아니라 normal이므로 normal로 초기화
    
    var projectContent = [ProjectContent]() // projectContent 배열
    //var projectDetailContent = [ProjectDetailContent]() // project Detail Content 배열
    
    var ref: DatabaseReference! = Database.database().reference() // realtime DB

    var email = "" //사용자 email을 저장할 변수
    var id: String = "" // 프로젝트의 uuid값을 받을 변수
    var currentPage: Int = 0 // 현재 페이지
    var currentTitle: String = "이름없음" // 현제 페이지의 title
    var projectTitle: String = ""
    
    @IBOutlet weak var headerView: ProjectHeaderView!
    @IBOutlet weak var stickyHeaderview: ProjectStickyHeaderView!
    
    @IBOutlet weak var addListButton: UIButton!
    @IBOutlet weak var contentTitleLabel: UILabel!
    @IBOutlet weak var listTitleLabel: UILabel!
    @IBOutlet weak var cardTableView: UITableView!
    @IBOutlet weak var projectTitleLabel: UILabel!
    
    @IBOutlet weak var moveLeftButton: UIButton!
    @IBOutlet weak var moveRightButton: UIButton!
    
    @IBOutlet weak var titleStackView: UIStackView! // projectTitle, listTitle
    @IBOutlet weak var headerViewHeightAnchor: NSLayoutConstraint!
    @IBOutlet weak var stickyHeaderViewHeightAnchor: NSLayoutConstraint!
    @IBOutlet weak var stickyHeaderViewTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var headerViewTopAnchor: NSLayoutConstraint!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.configureLabel()
        //collectionview cell 등록
        let tableViewNib = UINib(nibName: "ProjectCardCell", bundle: nil)
        self.cardTableView.register(tableViewNib, forCellReuseIdentifier: "ProjectCardCell")
        
        self.cardTableView.rowHeight = UITableView.automaticDimension
        self.cardTableView.estimatedRowHeight = 100
        
        self.cardTableView.delegate = self
        self.cardTableView.dataSource = self
        
        self.cardTableView.layer.shadowColor = UIColor.black.cgColor // any value you want
        self.cardTableView.layer.shadowOpacity = 0.1 // any value you want
        self.cardTableView.layer.shadowRadius = 5.0 // any value you want
        self.cardTableView.layer.shadowOffset = .init(width: 1, height: 1)
        
        let tabTitleLabel = UITapGestureRecognizer(target: self, action: #selector(tabContentTitleLabel))
        self.contentTitleLabel.isUserInteractionEnabled = true
        self.contentTitleLabel.addGestureRecognizer(tabTitleLabel)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("viewwillappear실행")
        self.readDB()
        self.setNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        print("viewwillDisappear실행")
        self.removeNotification()
        self.projectContent.removeAll()
    }
    
    /// 뒤로가기 버튼(Maintabbarview로 돌아감)
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: false)
    }
    
    /// list 추가
    @IBAction func addListButton(_ sender: UIButton) {
        
        let addCardListPopup = AddCardListPopupViewController(nibName: "AddCardListPopup", bundle: nil)
        
        addCardListPopup.modalPresentationStyle = .overCurrentContext
        addCardListPopup.modalTransitionStyle = .crossDissolve // 뷰가 투명해지면서 넘어가는 애니메이션

        self.present(addCardListPopup, animated: false, completion: nil)

    }
    
    /// contentTitltLabel 클릭시 일어날 이벤트 작성
    @objc func tabContentTitleLabel(sender: UITapGestureRecognizer) {
        self.view.hideAllToasts()
        self.view.makeToast("\(currentTitle)")
    }
    
    
    // MARK: - 하단 버튼 이벤트
    @IBAction func moveLeft(_ sender: UIButton) {
        if currentPage > 0 {
            self.currentPage -= 1
            self.changeListName()
            
            DispatchQueue.main.async {
//                self.contentTitleLabel.text = self.currentTitle
                self.cardTableView.reloadData()
            }
            print("currentPage는",self.currentPage)
        }
    }
    
    @IBAction func moveRight(_ sender: UIButton) {
        if self.projectContent.count - 1 > currentPage {

            self.currentPage += 1
            DispatchQueue.main.async {
                self.changeListName()
//                self.contentTitleLabel.text = self.currentTitle
                self.cardTableView.reloadData()
            }
            print("currentPage는",currentPage)
        }
    }
    
    // tableview cell 길게 누르면 실행되는 메서드
    // cell을 이동시키고 db값 변경
    @IBAction func didLongPressCell(_ sender: UILongPressGestureRecognizer) {
        let longPressedPoint = sender.location(in: cardTableView)
        guard let indexPath = cardTableView.indexPathForRow(at: longPressedPoint) else { return }

        struct BeforeIndexPath {
            static var value: IndexPath?
        }
        
        switch sender.state {
        case .began:
            BeforeIndexPath.value = indexPath

        case .changed:
            if let beforeIndexPath = BeforeIndexPath.value, beforeIndexPath != indexPath {

                let beforeDetailContent = projectContent[currentPage].detailContent[beforeIndexPath.section]
                let afterDetailContent = projectContent[currentPage].detailContent[indexPath.section]
                
                var count = 0

                self.projectContent[currentPage].detailContent[beforeIndexPath.section] = afterDetailContent
                self.projectContent[currentPage].detailContent[indexPath.section] = beforeDetailContent

                cardTableView.moveSection(beforeIndexPath.section, toSection: indexPath.section)

                BeforeIndexPath.value = indexPath
                
                for i in self.projectContent[self.currentPage].detailContent {
                    let cardName = i.cardName
                    let color = i.color
                    let startTime = i.startTime
                    let endTime = i.endTime

                    let detailContent = ["cardName": cardName, "color": color, "startTime": startTime, "endTime": endTime]
                    self.ref.child("\(email)/\(id)/content/\(currentPage)/\(self.currentTitle)/\(count)").setValue(detailContent)
                    count += 1
                }
            }
        default:
            // TODO animation
            break
        }
    }
    
    @IBAction func showSideBar(_ sender: UIButton) {

        let listTitle = self.projectContent.map({ $0.listTitle })

        // sideMenu storyboard
        let projectContentSideMenu = UIStoryboard(name: "ProjectContentSideMenu", bundle: nil)

        // sideMenu viewController
        let projectSideBarViewController = projectContentSideMenu.instantiateViewController(withIdentifier: "ProjectSideBarViewController") as! ProjectListManagementViewController

        projectSideBarViewController.listName = listTitle
        projectSideBarViewController.projectTitle = self.projectTitle
        projectSideBarViewController.currentPage = self.currentPage
        projectSideBarViewController.projectContent = self.projectContent
        projectSideBarViewController.email = self.email
        projectSideBarViewController.id = self.id
        
        projectSideBarViewController.moveListDelegate = self
        projectSideBarViewController.changeCurrentPageDelegate = self
        
        projectSideBarViewController.modalPresentationStyle = .fullScreen
        
        present(projectSideBarViewController, animated: true, completion: nil)

    }
}

// 이메일을 string값으로 변환 시켜주는 메소드
// 전체 db값을 읽어오는 메소드
// db값중 content부분을 읽어오는 메소드
extension ProjectContentViewController {
    
    private func emailToString(_ email: String) -> String {
        let emailToString = email.replacingOccurrences(of: ".", with: ",")
        return emailToString
    }
    
    private func readDB() {
        print("readDB접속")
        
        self.ref.child("\(email)/\(id)/content").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let value = snapshot.value as? [[String: Any]] else { return }
            guard let self = self else { return }
            for list in value {
                var count = 0
                for (key, val) in list {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: val)
                        let projectContentData = try JSONDecoder().decode([ProjectDetailContent].self, from: jsonData)
                        self.projectContent.append(ProjectContent(listTitle: key, index: count, detailContent: projectContentData))
                        count += 1
                    }
                    catch {
                        print("Error JSON Parsing \(error.localizedDescription)")
                    }
                }
            }
            
            print(self.projectContent, "db잘 읽었나")
            DispatchQueue.main.async {
                self.cardTableView.reloadData()
                self.changeListName()
            }

        }) { error in
            print(error.localizedDescription)
        }
    }

    /// listTitle 변경
    func changeListName() {
        self.currentTitle = self.projectContent[currentPage].listTitle
        self.contentTitleLabel.text = currentTitle
        self.listTitleLabel.text = currentTitle
        self.view.hideAllToasts()
        self.view.makeToast("\(currentPage + 1) 페이지", duration: 0.5)
    }
    
    func changeCurrentPage(currentpPage: Int) {
        self.currentPage = currentpPage
    }
    
    private func koreanDate() -> Int!{
        let current = Date()
        
        let formatter = DateFormatter()
        //한국 시간으로 표시
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        //형태 변환
        formatter.dateFormat = "yyyyMMdd"
        
        return Int(formatter.string(from: current))
    }
}


// MARK: - tableview
extension ProjectContentViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5.0
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.projectContent.isEmpty { return 0 } else { return self.projectContent[currentPage].detailContent.count }
    }
    
}

extension ProjectContentViewController: UITableViewDataSource {
    
    // row는 section마다 1개씩
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cardTableView.dequeueReusableCell(withIdentifier: "ProjectCardCell", for: indexPath) as! ProjectContentTableViewCell
        
        let startTime = self.projectContent[self.currentPage].detailContent[indexPath.section].startTime ?? ""
        
        let endTime = self.projectContent[self.currentPage].detailContent[indexPath.section].endTime ?? ""
        
        
        let cardColor: UIColor = {
            switch projectContent[self.currentPage].detailContent[indexPath.section].color {
            case "blue": return UIColor.blue
            case "green": return UIColor.green
            case "orange": return UIColor.orange
            case "purple": return UIColor.purple
            case "yellow": return UIColor.yellow
            default: return UIColor.lightGray
            }
        }()
        
        cell.moveContentDelegate = self
        cell.makeToastMessage = self
        
        cell.projectListArray = projectContent
        
        cell.contentLabel.isHidden = false
        cell.cardColor.layer.borderColor = cardColor == UIColor.lightGray ? UIColor.lightGray.cgColor : UIColor.clear.cgColor
        cell.cardColor.layer.borderWidth = cardColor == UIColor.lightGray ? 2 : 0
        cell.contentLabel.text = self.projectContent[self.currentPage].detailContent[indexPath.section].cardName
        cell.cardColor.backgroundColor = cardColor == UIColor.lightGray ? .white : cardColor
        
        cell.timeLabel.text = "\(startTime) ~ \(endTime)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "ProjectDetailContent", bundle: Bundle.main)
        guard let detailContentViewController = storyboard.instantiateViewController(withIdentifier: "DetailContentViewController") as? DetailContentViewController else { return }
        
        detailContentViewController.sendCellIndexDelegate = self
        detailContentViewController.sendContentDelegate = self
        
        // currentpage에 있는 projectDetailContent 값을 전달
        detailContentViewController.projectDetailContent = self.projectContent[currentPage].detailContent[indexPath.section]
        detailContentViewController.index = indexPath.section
        
        self.present(detailContentViewController, animated: true, completion: nil)
    }

    // 편집모드에서 할일의 순서를 변경하는 메소드(canmoverowat, moverowat)
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //왼쪽으로 슬라이스 할시 cell삭제
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        //cell삭제 함수
        self.deleteCell(indexPath.section)
        
        DispatchQueue.main.async {
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // cell 삭제
    func deleteCell(_ index: Int) {
        // 배열에서 삭제
        self.projectContent[self.currentPage].detailContent.remove(at: index)
        self.ref.child("\(email)/\(id)/content/\(currentPage)/\(self.currentTitle)").removeValue()
        //배열 중간값이 삭제될수 있기 떄문에 db배열을 갱신해줘야함
        var count = 0
        
        for i in self.projectContent[self.currentPage].detailContent {
            let cardName = i.cardName
            let color = i.color
            let startTime = i.startTime
            let endTime = i.endTime
            
            let detailContent = ["cardName": cardName, "color": color, "startTime": startTime, "endTime": endTime]
            
            self.ref.child("\(email)/\(id)/content/\(currentPage)/\(self.currentTitle)/\(count)").setValue(detailContent)
            count += 1
        }
    }
}



// MARK: - notification
extension ProjectContentViewController {
    
    fileprivate func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(addCardNotification), name: .addCardNotificaton, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addListNotification), name: .addListNotificaton, object: nil)
    }
    
    fileprivate func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: .addCardNotificaton, object: nil)
        NotificationCenter.default.removeObserver(self, name: .addListNotificaton, object: nil)
    }

    
    @objc func addCardNotification(_ notification: Notification) {

        let cardTitle = notification.object as! String
        
        //projectDetatailContent에 넣을 변수
        let updateContent = ["cardName": cardTitle, "color": "", "startTime": "", "endTime": ""] as [String: String]
        let updateProjectDetailContent = ProjectDetailContent(cardName: cardTitle, color: "", startTime: "", endTime: "")
        
        self.ref.child("\(self.email)/\(self.id)/content/\(self.currentPage)/\(self.currentTitle)").updateChildValues(["\(self.projectContent[self.currentPage].detailContent.count)": updateContent])
        
        self.projectContent[self.currentPage].detailContent.append(updateProjectDetailContent)
        
        DispatchQueue.main.async {
            self.cardTableView.reloadData()
        }
    }
    
    @objc func addListNotification(_ notification: Notification) {
        
        let listTitle = notification.object as! String

        //db에 저장할 변수
        let updateContent = ["cardName": "카드를 추가해주세요", "color": "", "startTime": "", "endTime": ""] as [String : String]
        
        //배열에 저장할 변수 [projectDetailContent]
        let updateProjectDetailContent = ProjectDetailContent(cardName: "카드를 추가해주세요", color: "", startTime: "", endTime: "")
        
        //list 추가
        self.ref.child("\(self.email)/\(self.id)/content/\(self.projectContent.count)/\(listTitle)/\(0)").updateChildValues(updateContent)
        
        let pc = ProjectContent(listTitle: listTitle, index: self.projectContent.count, detailContent: [updateProjectDetailContent])
        
        self.projectContent.append(pc)
        
        DispatchQueue.main.async {
            self.currentPage = self.projectContent.count - 1
            self.changeListName()
            self.cardTableView.reloadData()
        }
    }
}
