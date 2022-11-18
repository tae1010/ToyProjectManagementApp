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
    
    @IBOutlet weak var projectManagementButton: UIButton!
    @IBOutlet weak var projectColorButton: UIButton!
    
    @IBOutlet weak var titleStackView: UIStackView! // projectTitle, listTitle
    @IBOutlet weak var headerViewHeightAnchor: NSLayoutConstraint!
    @IBOutlet weak var stickyHeaderViewHeightAnchor: NSLayoutConstraint!
    @IBOutlet weak var stickyHeaderViewTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var headerViewTopAnchor: NSLayoutConstraint!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround() // 화면 클릭시 키보드 내림
        self.configureLabel()
        self.configureCardTableView()
        
        let tabTitleLabel = UITapGestureRecognizer(target: self, action: #selector(tabContentTitleLabel))
        self.contentTitleLabel.isUserInteractionEnabled = true
        self.contentTitleLabel.addGestureRecognizer(tabTitleLabel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print(#fileID, #function, #line, "- viewwillappear실행")
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
            
            DispatchQueue.main.async {
                self.changeListName()
                self.cardTableView.reloadData()
            }
        } else {
            self.view.hideAllToasts()
            self.view.makeToast("첫번째 리스트 입니다.")
        }
    }
    
    @IBAction func moveRight(_ sender: UIButton) {
        if self.projectContent.count - 1 > currentPage {
            self.currentPage += 1
            
            DispatchQueue.main.async {
                self.changeListName()
                self.cardTableView.reloadData()
            }
        } else {
            self.view.hideAllToasts()
            self.view.makeToast("마지막 리스트 입니다.")
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

            // cell이 이동될떄마다 projectContent변수 모델에 저장
        case .changed:
            if let beforeIndexPath = BeforeIndexPath.value, beforeIndexPath != indexPath {

                let beforeDetailContent = projectContent[currentPage].detailContent[beforeIndexPath.section]
                let afterDetailContent = projectContent[currentPage].detailContent[indexPath.section]

                self.projectContent[currentPage].detailContent[beforeIndexPath.section] = afterDetailContent
                self.projectContent[currentPage].detailContent[indexPath.section] = beforeDetailContent

                cardTableView.moveSection(beforeIndexPath.section, toSection: indexPath.section)

                BeforeIndexPath.value = indexPath
                
                print("move")
            }

        default:
            
            // cell 이동이 끝나면 db저장, userdefault에 알림 content 저장
            if let beforeIndexPath = BeforeIndexPath.value {
                
                let cardName = projectContent[currentPage].detailContent[beforeIndexPath.section].cardName ?? "이동"
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
                
                UserDefault().notificationModelUserDefault(title: cardName, status: "이동", content: "\"\(cardName)\" 카드가 이동되었습니다", date: self.koreanDate(), badge: true)
                
                print("default")
            }
            
            
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
    
    @IBAction func tabProjectColorCotentButton(_ sender: UIButton) {
        
        // sideMenu storyboard
        let projectColorContentStoryBoard = UIStoryboard(name: "ProjectContentColor", bundle: nil)

        // sideMenu viewController
        let projectColorContentViewController = projectColorContentStoryBoard.instantiateViewController(withIdentifier: "ProjectColorContentViewController") as! ProjectColorContentViewController
        
        projectColorContentViewController.modalPresentationStyle = .fullScreen
        projectColorContentViewController.id = self.id
        projectColorContentViewController.email = self.email
        
        present(projectColorContentViewController, animated: true, completion: nil)
    }
    
}

// 이메일을 string값으로 변환 시켜주는 메소드
// 전체 db값을 읽어오는 메소드
// db값중 content부분을 읽어오는 메소드
extension ProjectContentViewController {
    
    internal func koreanDate() -> Int!{
        let current = Date()
        
        let formatter = DateFormatter()
        //한국 시간으로 표시
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        //형태 변환
        formatter.dateFormat = "yyyyMMddHHmmss"
        
        return Int(formatter.string(from: current))
    }
    
    private func emailToString(_ email: String) -> String {
        let emailToString = email.replacingOccurrences(of: ".", with: ",")
        return emailToString
    }
    
    private func readDB() {
        self.hideViews()
        
        self.ref.child("\(email)/\(id)/content").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let self = self else { return }
            guard let value = snapshot.value as? [[String: Any]] else {
                self.showViews()
                return
            }
            print(#fileID, #function, #line, "- readDB실행앻앻애행ㅎ애")
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
                self.showViews()
                self.cardTableView.reloadData()
                self.changeListName()
            }

        }) { error in
            print(error.localizedDescription)
            self.showViews()
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
        
        let cardColor = self.projectContent[self.currentPage].detailContent[indexPath.section].color ?? ""
        
        let color = Color(rawValue: cardColor)
        let colorSelected = color?.create

        
        cell.moveContentDelegate = self
        cell.makeToastMessage = self
        
        cell.projectListArray = projectContent
        
        cell.contentLabel.isHidden = false
        cell.contentLabel.text = self.projectContent[self.currentPage].detailContent[indexPath.section].cardName
        
        cell.cardColor.layer.borderColor = cardColor == "" ? UIColor.lightGray.cgColor : UIColor.clear.cgColor
        cell.cardColor.layer.borderWidth = cardColor == "" ? 2 : 0
        cell.cardColor.backgroundColor = colorSelected
        
        if startTime == "" && endTime == "" {
            cell.timeLabel.isHidden = true
        } else {
            cell.timeLabel.isHidden = false
            cell.timeLabel.text = "\(startTime)  ~  \(endTime)"
        }

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
        detailContentViewController.email = self.email
        detailContentViewController.id = self.id
        
//        detailContentViewController.modalPresentationStyle = .fullScreen
        self.present(detailContentViewController, animated: true, completion: nil)
    }

    // 편집모드에서 할일의 순서를 변경하는 메소드(canmoverowat, moverowat)
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    
    // cell 삭제
    func deleteCell(_ index: Int) {
        // 배열에서 삭제
        
        if projectContent[self.currentPage].detailContent.count == 1 {
            self.view.hideAllToasts()
            self.view.makeToast("리스트에는 카드가 1개 이상 있어야 합니다")
            return
        }
        let deleteCardTitle = self.projectContent[self.currentPage].detailContent[index].cardName ?? "카드삭제"
        
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
        
        UserDefault().notificationModelUserDefault(title: deleteCardTitle, status: "삭제", content: "\"\(deleteCardTitle)\" 카드가 삭제되었습니다", date: self.koreanDate(), badge: true)
        
        self.view.hideAllToasts()
        self.view.makeToast("카드가 삭제되었습니다", duration: 0.5)
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
        
        let section = self.cardTableView.numberOfSections - 1
        let row = self.cardTableView.numberOfRows(inSection: section) - 1
        
        let indexPath = IndexPath(row: row, section: section)
        
        self.ref.child("\(self.email)/\(self.id)/content/\(self.currentPage)/\(self.currentTitle)").updateChildValues(["\(self.projectContent[self.currentPage].detailContent.count)": updateContent])
        
        self.projectContent[self.currentPage].detailContent.append(updateProjectDetailContent)
        
        UserDefault().notificationModelUserDefault(title: cardTitle, status: "생성", content: "\"\(cardTitle)\" 카드가 생성되었습니다", date: self.koreanDate(), badge: true)
        
        DispatchQueue.main.async {
            self.cardTableView.reloadData()
            self.cardTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            self.view.hideAllToasts()
            self.view.makeToast("카드가 생성되었습니다", duration: 0.5)
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
        
        UserDefault().notificationModelUserDefault(title: listTitle, status: "생성", content: "\"\(listTitle)\" 리스트가 생성되었습니다", date: self.koreanDate(), badge: true)
        
        DispatchQueue.main.async {
            self.currentPage = self.projectContent.count - 1
            self.changeListName()
            self.cardTableView.reloadData()
            
            self.view.hideAllToasts()
            self.view.makeToast("리스트가 생성되었습니다", duration: 0.5)
        }
    }
}


// MARK: - indicator
extension ProjectContentViewController {
    
    private func hideViews() {
        self.addListButton.isUserInteractionEnabled = false
        self.cardTableView.isUserInteractionEnabled = false
        self.moveLeftButton.isUserInteractionEnabled = false
        self.moveRightButton.isUserInteractionEnabled = false
        self.projectManagementButton.isUserInteractionEnabled = false
        self.projectColorButton.isUserInteractionEnabled = false
    }
    
    private func showViews() {
        
        self.addListButton.isUserInteractionEnabled = true
        self.cardTableView.isUserInteractionEnabled = true
        self.moveLeftButton.isUserInteractionEnabled = true
        self.moveRightButton.isUserInteractionEnabled = true
        self.projectManagementButton.isUserInteractionEnabled = true
        self.projectColorButton.isUserInteractionEnabled = true
        
    }

}
