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
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var addListButton: UIButton!
    @IBOutlet weak var contentTitleLabel: UILabel!
    @IBOutlet weak var cardTableView: UITableView!

    @IBOutlet weak var moveLeftButton: UIButton!
    @IBOutlet weak var moveRightButton: UIButton!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //collectionview cell 등록
        let tableViewNib = UINib(nibName: "ProjectCardCell", bundle: nil)
        self.cardTableView.register(tableViewNib, forCellReuseIdentifier: "ProjectCardCell")
        
        self.cardTableView.rowHeight = UITableView.automaticDimension
        self.cardTableView.estimatedRowHeight = 100
        
        self.cardTableView.delegate = self
        self.cardTableView.dataSource = self
        
        let tabTitleLabel = UITapGestureRecognizer(target: self, action: #selector(tabContentTitleLabel))
        self.contentTitleLabel.isUserInteractionEnabled = true
        self.contentTitleLabel.addGestureRecognizer(tabTitleLabel)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addCardNotification), name: .addCardNotificaton, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addListNotification), name: .addListNotificaton, object: nil)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("viewwillappear실행")
        self.readDB()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        print("viewwillDisappear실행")
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
        DispatchQueue.main.async {
            let title = self.contentTitleLabel.text
            self.contentTitleLabel.isHidden = true
            self.moveLeftButton.isEnabled = false
            self.moveRightButton.isEnabled = false
        }
    }
    
    /// contentTitle 변경버튼 클릭
//    @IBAction func tabEditContentTitleButton(_ sender: UIButton) {
//
//        let beforeTitle = self.currentTitle // 변경하기 전 contentTitle
//        guard let afterTitle = self.contentTitleTextField.text else { return } // 변경 후 contentTitle
//        var count = 0
//
//        // 변경된 db내용 삭제
//        self.ref.child("\(email)/\(id)/content/\(currentPage)").removeValue()
//
//        //변경된 내용 db저장
//        for i in self.projectContent[self.currentPage].detailContent {
//            let cardName = i.cardName
//            let color = i.color
//            let startTime = i.startTime
//            let endTime = i.endTime
//
//            let detailContent = ["cardName": cardName, "color": color, "startTime": startTime, "endTime": endTime]
//            let detailContentModel = ProjectDetailContent(cardName: cardName, color: color, startTime: startTime, endTime: endTime)
//
//            self.ref.child("\(email)/\(id)/content/\(currentPage)/\(afterTitle)/\(count)").setValue(detailContent)
//
//            self.projectContent[self.currentPage].detailContent.append(detailContentModel)
//            count += 1
//        }
//
//        self.projectContent[self.currentPage].listTitle = afterTitle
//
//        DispatchQueue.main.async {
//            self.contentTitleLabel.text = self.contentTitleTextField.text
//            self.contentTitleTextField.isHidden = true
//            self.editContentTitleButton.isHidden = true
//            self.contentTitleLabel.isHidden = false
//            self.moveLeftButton.isEnabled = true
//            self.moveRightButton.isEnabled = true
//        }
//    }
    
    // MARK: - 하단 버튼 이벤트
    @IBAction func moveLeft(_ sender: UIButton) {
        if currentPage > 0 {
            self.currentPage -= 1
            self.changeListName()
            
            DispatchQueue.main.async {
                self.contentTitleLabel.text = self.currentTitle
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
                self.contentTitleLabel.text = self.currentTitle
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
        print(indexPath,"인덱스")
//        guard let indexSectionPath = cardTableView.indexSection
//        cardTableView.sectionIndex

        struct BeforeIndexPath {
            static var value: IndexPath?
        }
        
        switch sender.state {
        case .began:
            BeforeIndexPath.value = indexPath
            print("눌림?")
        case .changed:
            if let beforeIndexPath = BeforeIndexPath.value, beforeIndexPath != indexPath {

                let beforeDetailContent = projectContent[currentPage].detailContent[beforeIndexPath.section]
                let afterDetailContent = projectContent[currentPage].detailContent[indexPath.section]
                
                var count = 0

                self.projectContent[currentPage].detailContent[beforeIndexPath.section] = afterDetailContent
                self.projectContent[currentPage].detailContent[indexPath.section] = beforeDetailContent
                
                //projectDetailContent[beforeIndexPath.row]
//                cardTableView.moveRow(at: beforeIndexPath, to: indexPath)

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
        let projectSideBarViewController = projectContentSideMenu.instantiateViewController(withIdentifier: "ProjectSideBarViewController") as! ProjectSideBarViewController
        
        // sideMenu navigationController
        let menu = CustomSideMenuNavigation(rootViewController: projectSideBarViewController)
        projectSideBarViewController.sendPageDelegate = self
        
        projectSideBarViewController.listName = listTitle
        projectSideBarViewController.projectTitle = self.projectTitle
        present(menu, animated: true, completion: nil)
        
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
        self.ref.child("\(email)/\(id)/content").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else { return }
            print(value,"흠")
            
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
            
            DispatchQueue.main.async {
                self.cardTableView.reloadData()
                self.changeListName()
            }

        }) { error in
            print(error.localizedDescription)
        }
    }

    
    /// listTitle 변경
    private func changeListName() {
        self.currentTitle = self.projectContent[currentPage].listTitle
        self.contentTitleLabel.text = currentTitle
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
        
        cell.moveContentDelegate = self
        
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

        switch self.mode {
        // 편집모드가 아닐때
        case .normal:

            DispatchQueue.main.async {
                cell.contentLabel.isHidden = false
                cell.cardColor.layer.borderWidth = cardColor == UIColor.lightGray ? 1 : 0
                cell.contentLabel.text = self.projectContent[self.currentPage].detailContent[indexPath.section].cardName
                cell.cardColor.backgroundColor = cardColor == UIColor.lightGray ? .white : cardColor
            }
            
        // 편집모드 일때
        default:
            DispatchQueue.main.async {
                cell.contentLabel.isHidden = true

                cell.cardColor.isHidden = true

                cell.cardColor.backgroundColor = cardColor
            }
            
        }
        print("cell이 리턴됨")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailContentViewController") as? DetailContentViewController else { return }
        
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

// MARK: - currentPage이동
extension ProjectContentViewController: MoveContentDelegate {
    func moveContentTapButton(cell: UITableViewCell, tag: Int) {
        guard let indexPath = self.cardTableView.indexPath(for: cell) else {return}
        var count = 0
        //tag가 1이면 left버튼, 현재 페이지가 0이상일때만, detailContent의 내용이 2개 이상일때만(내용이 1개만 있으면 cell을 삭제할경우 빈배열이 되어 db에 저장이 되지않는다.),(오른쪽 버튼 누를때도 같음)
        
        if tag == 1, currentPage > 0, self.projectContent[self.currentPage].detailContent.count > 1 {
            //현재 페이지의 content배열에서 삭제 -> projectcontent 배열에 저장 -> 바뀐 projectContent를 db에 저장
            
            let moveDetailContent: ProjectDetailContent = self.projectContent[self.currentPage].detailContent[indexPath.section] // 이동시킬 셀 내용
            
            self.projectContent[self.currentPage].detailContent.remove(at: indexPath.section)
            self.ref.child("\(email)/\(id)/content/\(currentPage)/\(self.currentTitle)").removeValue()
            print(count,"@@111111111111")
            for i in self.projectContent[self.currentPage].detailContent {

                let cardName = i.cardName ?? ""
                let color = i.color ?? ""
                let startTime = i.startTime ?? ""
                let endTime = i.endTime ?? ""

                self.ref.child("\(email)/\(id)/content/\(currentPage)/\(currentTitle)/\(count)").setValue(["cardName": cardName, "color": color, "startTime": startTime, "endTime": endTime])
                count += 1
            }
            
            // 현재 페이지를 왼쪽으로 옮김 -> 옮긴 페이지의 listName값을 불러오고 그 detailContent에 위에 삭제시킨 cell을 추가 -> 바뀐 detailContent값을 projectContent에 저장 -> 테이블뷰 새로고침 -> 바뀐 페이지의 내용을 db에 저장
            self.currentPage -= 1
            self.changeListName()
            self.projectContent[self.currentPage].detailContent.insert(moveDetailContent, at: 0)
            self.cardTableView.reloadData()
            count = 0
            
            self.ref.child("\(email)/\(id)/content/\(currentPage)/\(self.currentTitle)").removeValue()
            print(count,"@@2222222222")
            for i in self.projectContent[self.currentPage].detailContent {
                
                let cardName = i.cardName ?? ""
                let color = i.color ?? ""
                let startTime = i.startTime ?? ""
                let endTime = i.endTime ?? ""
                
                self.ref.child("\(email)/\(id)/content/\(currentPage)/\(currentTitle)/\(count)").setValue(["cardName": cardName, "color": color, "startTime": startTime, "endTime": endTime])
                count += 1
            }
            
        }
        
        //tag가 2이면 right버튼, 현재 페이지가 projectContent배열 갯수보다 작아야함, 페이지 갯수가 리스트 갯수를 넘으면 안됨
        if tag == 2, self.projectContent[self.currentPage].detailContent.count > 1, self.projectContent.count - 1 > currentPage {
            
            //현재 페이지의 content배열, projectDetailContent배열에서 삭제 -> projectcontent 배열에 저장 -> 바뀐 내용을 db에 저장
            let moveDetailContent = self.projectContent[self.currentPage].detailContent[indexPath.section]
            var count = 0
            self.projectContent[self.currentPage].detailContent.remove(at: indexPath.section)
            
            self.ref.child("\(email)/\(id)/content/\(currentPage)/\(self.currentTitle)").removeValue()
            for i in self.projectContent[self.currentPage].detailContent {
                
                let cardName = i.cardName ?? ""
                let color = i.color ?? ""
                let startTime = i.startTime ?? ""
                let endTime = i.endTime ?? ""
                
                self.ref.child("\(email)/\(id)/content/\(currentPage)/\(currentTitle)/\(count)").setValue(["cardName": cardName, "color": color, "startTime": startTime, "endTime": endTime])
                count += 1
            }
            
            self.currentPage += 1
            self.changeListName()
            self.projectContent[self.currentPage].detailContent.insert(moveDetailContent, at: 0)
            self.cardTableView.reloadData()
            
            self.ref.child("\(email)/\(id)/content/\(currentPage)/\(self.currentTitle)").removeValue()
            count = 0
            for i in self.projectContent[self.currentPage].detailContent {
                
                let cardName = i.cardName ?? ""
                let color = i.color ?? ""
                let startTime = i.startTime ?? ""
                let endTime = i.endTime ?? ""
                
                self.ref.child("\(email)/\(id)/content/\(currentPage)/\(currentTitle)/\(count)").setValue(["cardName": cardName, "color": color, "startTime": startTime, "endTime": endTime])
                count += 1
            }
        }
    }
}

// detailContentView에서 보낸 값을 db에 저장하고 테이블 reload
extension ProjectContentViewController: SendContentDelegate {
    func sendContent(_ name: String, _ index: Int, _ color: String, _ startTime: String, _ endTime: String) {
        
        // realtime DB작성
        self.projectContent[self.currentPage].detailContent[index].cardName = name
        self.projectContent[self.currentPage].detailContent[index].startTime = startTime
        self.projectContent[self.currentPage].detailContent[index].endTime = endTime
        self.projectContent[self.currentPage].detailContent[index].color = color
        
        self.cardTableView.reloadRows(at: [[index,0]], with: .automatic) // 선택된 cell 갱신
        self.ref.child("\(email)/\(id)/content/\(currentPage)/\(currentTitle)/\(index)").updateChildValues(["cardName": name, "color": color, "startTime": startTime, "endTime": endTime])
        
        // firestore DB작성
        
        
    }
}

// card 지우기
extension ProjectContentViewController: DeleteCellDelegate {
    func sendCellIndex(_ index: IndexPath) {
        self.deleteCell(index.section)
        
        DispatchQueue.main.async {
            self.cardTableView.deleteRows(at: [index], with: .automatic)
        }
    }
}

extension ProjectContentViewController: SendPageDelegate {
    func sendPage(_ index: IndexPath) {
        self.currentPage = index.section
        
        DispatchQueue.main.async {
            self.changeListName()
            self.cardTableView.reloadData()
        }
    }
}


extension ProjectContentViewController: SideMenuNavigationControllerDelegate {

    func sideMenuWillAppear(menu: SideMenuNavigationController, animated: Bool) {
        print("willAppear")
    }

    func sideMenuDidAppear(menu: SideMenuNavigationController, animated: Bool) {

    }

    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
    }

    func sideMenuDidDisappear(menu: SideMenuNavigationController, animated: Bool) {

    }
}

// MARK: - notification
extension ProjectContentViewController {
    
    @objc func addCardNotification(_ notification: Notification) {
        
        let cardTitle = notification.object as! String
        
        //projectDetatailContent에 넣을 변수
        let updateContent = ["cardName": cardTitle, "color": "", "startTime": "", "endTime": ""] as [String: String]
        let updateProjectDetailContent = ProjectDetailContent(cardName: cardTitle, color: "", startTime: "", endTime: "")
        
        //projectContent[self.currentPage].detailContent
        // content 값 작성
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
