//
//  ProjectViewController.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/05/11.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SideMenu

// cell편집모드(cell 내용 수정, cell 양옆(다른 currentPage로 이동))
enum Mode {
    case edit
    case normal
}

class ProjectViewController: UIViewController {
    
    var mode: Mode = .normal // 평상시 상태는 edit상태가 아니라 normal이므로 normal로 초기화
    
    var projectContent = [ProjectContent]() // projectContent 배열
    //var projectDetailContent = [ProjectDetailContent]() // project Detail Content 배열
    
    var ref: DatabaseReference! = Database.database().reference()

    var email = "" //사용자 email을 저장할 변수
    var id: String = "" // 프로젝트의 uuid값을 받을 변수
    var currentPage: Int = 0 // 현재 페이지
    var currentTitle: String = "이름없음" // 현제 페이지의 title
    var projectTitle: String = ""
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var addCardButton: UIButton!
    @IBOutlet weak var addListButton: UIButton!
    @IBOutlet weak var contentTitleLabel: UILabel!
    @IBOutlet weak var contentTitleTextField: UITextField!
    @IBOutlet weak var editContentTitleButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var moveLeftButton: UIButton!
    @IBOutlet weak var moveRightButton: UIButton!
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {

        self.tableView.delegate = self
        self.tableView.dataSource = self

        //collectionview cell 등록
        let tableViewNib = UINib(nibName: "ProjectContentCell", bundle: nil)
        self.tableView.register(tableViewNib, forCellReuseIdentifier: "ProjectContentCell")
        
        let tabTitleLabel = UITapGestureRecognizer(target: self, action: #selector(tabContentTitleLabel))
        self.contentTitleLabel.isUserInteractionEnabled = true
        self.contentTitleLabel.addGestureRecognizer(tabTitleLabel)
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
    
    
    // MARK: - 상단 button 이벤트
    
    /// cell 수정모드
    @IBAction func cardEditButton(_ sender: UIButton) {
        switch self.mode {
        case .normal:
            DispatchQueue.main.async {
                self.addCardButton.isHidden = true
                self.addListButton.isHidden = true
                self.editButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
                self.tableView.reloadData()
                self.mode = .edit
            }

        //편집모드일때
        default:
            DispatchQueue.main.async {
                self.addCardButton.isHidden = false
                self.addListButton.isHidden = false
                self.editButton.setImage(UIImage(systemName: "pencil"), for: .normal)
                self.tableView.reloadData()
                self.mode = .normal
            }
        }
    }
    
    /// card 추가하기
    @IBAction func addCardView(_ sender: UIButton) {

        let alert = UIAlertController(title: "카드 추가", message: nil, preferredStyle: .alert)
        //alert 등록버튼
        let registerButton = UIAlertAction(title: "추가", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            guard let content = alert.textFields?[0].text else { return }
            
            // 경로중 self.content.count라고 안하고 "\(self.content.count)" 라고 작성한 이유는 경로를 찾을때는 string값만 허용
            
            //projectDetatailContent에 넣을 변수
            let updateContent = ["cardName": content, "color": "", "startTime": "", "endTime": ""] as [String: String]
            let updateProjectDetailContent = ProjectDetailContent(cardName: content, color: "", startTime: "", endTime: "")
            
            //projectContent[self.currentPage].detailContent
            // content 값 작성
            self.ref.child("\(self.email)/\(self.id)/content/\(self.currentPage)/\(self.currentTitle)").updateChildValues(["\(self.projectContent[self.currentPage].detailContent.count)": updateContent])

            self.projectContent[self.currentPage].detailContent.append(updateProjectDetailContent)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        
        //alert 취소버튼
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(registerButton)
        alert.addAction(cancelButton)
        
        alert.addTextField(configurationHandler: { textfield in
            textfield.placeholder = "내용을 입력해주세요."
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    /// list 추가
    @IBAction func addListButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "리스트 추가", message: nil, preferredStyle: .alert)
        
        let registerButton = UIAlertAction(title: "추가", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            guard let content = alert.textFields?[0].text else { return }
            
            //db에 저장할 변수
            let updateContent = ["cardName": "카드를 추가해주세요", "color": "", "startTime": "", "endTime": ""] as [String : String]
            
            //배열에 저장할 변수 [projectDetailContent]
            let updateProjectDetailContent = ProjectDetailContent(cardName: "카드를 추가해주세요", color: "", startTime: "", endTime: "")
            
            //list 추가
            self.ref.child("\(self.email)/\(self.id)/content/\(self.projectContent.count)/\(content)/\(0)").updateChildValues(updateContent)
            
            let pc = ProjectContent(listTitle: content, index: self.projectContent.count, detailContent: [updateProjectDetailContent])
            
            self.projectContent.append(pc)
            
            DispatchQueue.main.async {
                self.currentPage = self.projectContent.count - 1
                self.changeListName()
                self.tableView.reloadData()
            }
        })
        
        //alert 취소버튼
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(registerButton)
        alert.addAction(cancelButton)
        
        alert.addTextField(configurationHandler: { textfield in
            textfield.placeholder = "내용을 입력해주세요."
        })
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    /// contentTitltLabel 클릭시 일어날 이벤트 작성
    @objc func tabContentTitleLabel(sender: UITapGestureRecognizer) {
        DispatchQueue.main.async {
            let title = self.contentTitleLabel.text
            self.contentTitleTextField.isHidden = false
            self.editContentTitleButton.isHidden = false
            self.contentTitleLabel.isHidden = true
            self.moveLeftButton.isEnabled = false
            self.moveRightButton.isEnabled = false
            self.contentTitleTextField.text = title
        }
    }
    
    /// contentTitle 변경버튼 클릭
    @IBAction func tabEditContentTitleButton(_ sender: UIButton) {
        
        let beforeTitle = self.currentTitle // 변경하기 전 contentTitle
        guard let afterTitle = self.contentTitleTextField.text else { return } // 변경 후 contentTitle
        var count = 0
        
        // 변경된 db내용 삭제
        self.ref.child("\(email)/\(id)/content/\(currentPage)").removeValue()
        
        //변경된 내용 db저장
        for i in self.projectContent[self.currentPage].detailContent {
            let cardName = i.cardName
            let color = i.color
            let startTime = i.startTime
            let endTime = i.endTime

            let detailContent = ["cardName": cardName, "color": color, "startTime": startTime, "endTime": endTime]
            let detailContentModel = ProjectDetailContent(cardName: cardName, color: color, startTime: startTime, endTime: endTime)
            
            self.ref.child("\(email)/\(id)/content/\(currentPage)/\(afterTitle)/\(count)").setValue(detailContent)

            self.projectContent[self.currentPage].detailContent.append(detailContentModel)
            count += 1
        }
        
        self.projectContent[self.currentPage].listTitle = afterTitle
        
        DispatchQueue.main.async {
            self.contentTitleLabel.text = self.contentTitleTextField.text
            self.contentTitleTextField.isHidden = true
            self.editContentTitleButton.isHidden = true
            self.contentTitleLabel.isHidden = false
            self.moveLeftButton.isEnabled = true
            self.moveRightButton.isEnabled = true
        }
    }
    
    // MARK: - 하단 버튼 이벤트
    @IBAction func moveLeft(_ sender: UIButton) {
        if currentPage > 0 {
            self.currentPage -= 1
            self.changeListName()
            
            DispatchQueue.main.async {
                self.contentTitleLabel.text = self.currentTitle
                self.tableView.reloadData()
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
                self.tableView.reloadData()
            }
            print("currentPage는",currentPage)
        }
    }
    
    // tableview cell 길게 누르면 실행되는 메서드
    // cell을 이동시키고 db값 변경
    @IBAction func didLongPressCell(_ sender: UILongPressGestureRecognizer) {
        let longPressedPoint = sender.location(in: tableView)
        guard let indexPath = tableView.indexPathForRow(at: longPressedPoint) else { return }

        struct BeforeIndexPath {
            static var value: IndexPath?
        }
        
        switch sender.state {
        case .began:
            BeforeIndexPath.value = indexPath
        case .changed:
            if let beforeIndexPath = BeforeIndexPath.value, beforeIndexPath != indexPath {

                let beforeDetailContent = projectContent[currentPage].detailContent[beforeIndexPath.row]
                let afterDetailContent = projectContent[currentPage].detailContent[indexPath.row]
                
                var count = 0

                self.projectContent[currentPage].detailContent[beforeIndexPath.row] = afterDetailContent
                self.projectContent[currentPage].detailContent[indexPath.row] = beforeDetailContent
                
                //projectDetailContent[beforeIndexPath.row]
                tableView.moveRow(at: beforeIndexPath, to: indexPath)

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
extension ProjectViewController {
    
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
                self.tableView.reloadData()
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
        // projectContent의 intex가 currentPage와 같으면 currentTitle을 그 인덱스에 있는 listTitle로 변경
//        if let index = self.projectContent.firstIndex(where: { $0.index == self.currentPage }) {
//             = self.projectContent[index].listTitle
//        }
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
extension ProjectViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

extension ProjectViewController: UITableViewDataSource {
    
    //cell 클릭시
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let detailContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailContentViewController") as? DetailContentViewController else { return }
        
        detailContentViewController.sendCellIndexDelegate = self
        detailContentViewController.sendContentDelegate = self
        
        // currentpage에 있는 projectDetailContent 값을 전달
        detailContentViewController.projectDetailContent = self.projectContent[currentPage].detailContent[indexPath.row]
        detailContentViewController.index = indexPath.row
        
        
        self.present(detailContentViewController, animated: true, completion: nil)
    }
    
    
    //content의 배열 인덱스 갯수 만큼 return
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.projectContent.isEmpty { return 0 } else { return self.projectContent[currentPage].detailContent.count }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectContentCell", for: indexPath) as! ProjectContentTableViewCell
        
        cell.selectionStyle = .none
        cell.moveContentDelegate = self
        
        let cardColor: UIColor = {
            switch projectContent[self.currentPage].detailContent[indexPath.row].color {
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
                cell.editModeStackView.isHidden = true
                cell.cardColor.isHidden = cardColor == UIColor.lightGray ? true : false
                cell.contentLabel.text = self.projectContent[self.currentPage].detailContent[indexPath.row].cardName
                cell.cardColor.backgroundColor = cardColor
            }
            
        // 편집모드 일때
        default:
            DispatchQueue.main.async {
                cell.contentLabel.isHidden = true
                cell.editModeStackView.isHidden = false
                cell.cardColor.isHidden = true
                cell.contentTextView.text = self.projectContent[self.currentPage].detailContent[indexPath.row].cardName
                cell.cardColor.backgroundColor = cardColor
            }
            
        }
        print("cell이 리턴됨")
        return cell
    }
    
    //편집모드에서 할일의 순서를 변경하는 메소드(canmoverowat, moverowat)
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //왼쪽으로 슬라이스 할시 cell삭제
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        //cell삭제 함수
        self.deleteCell(indexPath.row)
        
        DispatchQueue.main.async {
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
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
extension ProjectViewController: MoveContentDelegate {
    func moveContentTapButton(cell: UITableViewCell, tag: Int) {
        guard let indexPath = self.tableView.indexPath(for: cell) else {return}
        var count = 0
        //tag가 1이면 left버튼, 현재 페이지가 0이상일때만, detailContent의 내용이 2개 이상일때만(내용이 1개만 있으면 cell을 삭제할경우 빈배열이 되어 db에 저장이 되지않는다.),(오른쪽 버튼 누를때도 같음)
        
        if tag == 1, currentPage > 0, self.projectContent[self.currentPage].detailContent.count > 1 {
            //현재 페이지의 content배열에서 삭제 -> projectcontent 배열에 저장 -> 바뀐 projectContent를 db에 저장
            
            let moveDetailContent: ProjectDetailContent = self.projectContent[self.currentPage].detailContent[indexPath.row] // 이동시킬 셀 내용
            
            self.projectContent[self.currentPage].detailContent.remove(at: indexPath.row)
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
            self.tableView.reloadData()
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
            let moveDetailContent = self.projectContent[self.currentPage].detailContent[indexPath.row]
            var count = 0
            self.projectContent[self.currentPage].detailContent.remove(at: indexPath.row)
            
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
            self.tableView.reloadData()
            
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
extension ProjectViewController: SendContentDelegate {
    func sendContent(_ name: String, _ index: Int, _ color: String, _ startTime: String, _ endTime: String) {
        self.projectContent[self.currentPage].detailContent[index].cardName = name
        self.projectContent[self.currentPage].detailContent[index].startTime = startTime
        self.projectContent[self.currentPage].detailContent[index].endTime = endTime
        self.projectContent[self.currentPage].detailContent[index].color = color
        
        self.tableView.reloadRows(at: [[0,index]], with: .automatic) // 선택된 cell 갱신
        self.ref.child("\(email)/\(id)/content/\(currentPage)/\(currentTitle)/\(index)").updateChildValues(["cardName": name, "color": color, "startTime": startTime, "endTime": endTime])
        
        
    }
}

// card 지우기
extension ProjectViewController: DeleteCellDelegate {
    func sendCellIndex(_ index: IndexPath) {
        self.deleteCell(index.row)
        
        DispatchQueue.main.async {
            self.tableView.deleteRows(at: [index], with: .automatic)
        }
    }
}

extension ProjectViewController: SendPageDelegate {
    func sendPage(_ index: IndexPath) {
        self.currentPage = index.row
        print(index.row,"?????")
        print(currentPage)
        print(projectContent[index.row].detailContent,"?")
        
        DispatchQueue.main.async {
            print("이거 안됨??")
            self.changeListName()
            self.tableView.reloadData()
        }
    }
}


extension ProjectViewController: SideMenuNavigationControllerDelegate {
    
    

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
