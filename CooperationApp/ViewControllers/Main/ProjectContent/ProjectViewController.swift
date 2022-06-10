//
//  ProjectViewController.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/05/11.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

// cell편집모드(cell 내용 수정, cell 양옆(다른 currentPage로 이동))
enum Mode {
    case edit
    case normal
}

class ProjectViewController: UIViewController {
    var email = "" //사용자 email을 저장할 변수
    var mode: Mode = .normal // 평상시상태는 edit상태가 아니라 normal이므로 normal로 초기화
    
    //ProjectContent(id: String, countIndex: Int, content: Dictionary<String, [String]>)
    var projectContent = [ProjectContent]() // project model 배열
    var content = [String]() //projectcontent model의 content.value값을 저장 [String] // currentCount값에 따라 바뀜
    
    //편집모드에 들어갈때 바뀐 textview를 저장시키고 content배열에 넣어줄 배열
    var contentArray = [String]()
    
    var ref: DatabaseReference! = Database.database().reference()
    var id: String = "" // 프로젝트의 uuid값을 받을 변수
    var currentPage: Int = 0 //현재 페이지
    var currentTitle: String = "이름없음" // 현제 페이지의 title
    
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
        self.email = self.emailToString(Auth.auth().currentUser?.email ?? "고객") // 이메일변수 내가 로그인 한 아이디로 초기화
        
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
        self.readContents()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        print("viewwillDisappear실행")
        self.projectContent.removeAll()
        self.content.removeAll()
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
    
    @IBAction func addCardView(_ sender: UIButton) {

        let alert = UIAlertController(title: "카드 추가", message: nil, preferredStyle: .alert)
        //alert 등록버튼
        let registerButton = UIAlertAction(title: "추가", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            guard let content = alert.textFields?[0].text else { return }
            
            // 경로중 self.content.count라고 안하고 "\(self.content.count)" 라고 작성한 이유는 경로를 찾을때는 string값만 허용
            // content 값 작성
            self.ref.child("\(self.email)/\(self.id)/content/\(self.currentPage)/\(self.currentTitle)").updateChildValues(["\(self.content.count)": content])
            
            self.content.append(content)
            self.projectContent[self.currentPage].content[self.currentTitle] = self.content
            
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
            self.ref.child("\(self.email)/\(self.id)/content/\(self.projectContent.count)/\(content)").updateChildValues(["0": "카드를 추가해주세요"])
            let pc = ProjectContent(id: self.id, countIndex: self.projectContent.count, content: ["\(content)": ["카드를 추가해주세요"]])
            self.projectContent.append(pc)
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
    
    /// contentTitle 변경
    @IBAction func tabEditContentTitleButton(_ sender: UIButton) {
        
        //변경된 title db저장
        guard let title = self.contentTitleTextField.text else { return }
        self.ref.child("\(self.email)/\(self.id)/content/\(self.currentPage)").setValue(["\(title)": self.content])
        
        //변경된 title projectContent배열에 저장
        projectContent[currentPage].content = [title: content]
        
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
            self.readContents()
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
                self.readContents()
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
                
                let beforeValue = content[beforeIndexPath.row]
                let afterValue = content[indexPath.row]
                content[beforeIndexPath.row] = afterValue
                content[indexPath.row] = beforeValue
                tableView.moveRow(at: beforeIndexPath, to: indexPath)

                BeforeIndexPath.value = indexPath
                
                self.ref.child("\(email)/\(id)/content/\(currentPage)/\(currentTitle)").setValue(self.content)
                self.projectContent[self.currentPage].content[self.currentTitle] = self.content
                
            }
        default:
            // TODO animation
            break
        }
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
    
        let email = self.emailToString(Auth.auth().currentUser?.email ?? "고객")
        
        ref.child(email).child(id).child("content").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [Dictionary<String, [String]>] else {return}
            
            for content in value {
                guard let count = value.firstIndex(of: content) else { return }
                let pc = ProjectContent(id: self.id, countIndex: count, content: content)
                self.projectContent.append(pc)
            }
            
            DispatchQueue.main.async {
                self.readContents()
                self.contentTitleLabel.text = self.currentTitle
                self.tableView.reloadData()
            }
            
            print("readDB실행",self.projectContent)
            
        }) { error in
          print(error.localizedDescription)
        }
    }
    
    /// content 배열 작성
    //readDB에서 저장시킨 projectContent모델에서 현재 페이지의 content.value(content의 내용)값과 content.key(content의 title)를 저장시키는 함수, contentTitleLabel의 text값을 바꿔줌 -> content값을 그 페이지의 content 값으로 변경
    private func readContents() {
        for pc in self.projectContent{
            if pc.countIndex == currentPage {
                //2차원 배열을 1차원으로 바꿔줌
                self.currentTitle = pc.content.keys.joined(separator: "")
                self.content = Array(pc.content.values.joined())
            }
        }
        print("readContents실행",self.currentPage)
    }
    


}


// MARK: - tableview
extension ProjectViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

extension ProjectViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let detailContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailContentViewController") as? DetailContentViewController else { return }
        detailContentViewController.index = indexPath.row
        detailContentViewController.content = content[indexPath.row]
        detailContentViewController.delegate = self

        self.present(detailContentViewController, animated: true, completion: nil)
    }
    
    //content의 배열 인덱스 갯수 만큼 return
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectContentCell", for: indexPath) as! ProjectContentTableViewCell
        cell.selectionStyle = .none
        cell.moveContentDelegate = self
        
        switch self.mode {
            
        case .normal:
            cell.contentLabel.isHidden = false
            cell.editModeStackView.isHidden = true
            cell.contentLabel.text = self.content[indexPath.row]
//            self.content[content.count - indexPath.row - 1] = cell.contentTextView.text
            
        default:
            cell.contentLabel.isHidden = true
            cell.editModeStackView.isHidden = false
            cell.contentTextView.text = self.content[indexPath.row]
            
        }
        return cell
    }
    
    //편집모드에서 할일의 순서를 변경하는 메소드(canmoverowat, moverowat)
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //편집모드에서 삭제버튼을 누를떄 어떤셀인지 알려주는 메서드
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //편집모드에서 삭제할수 있고 편집모드를 들어가지 않아도 스와이프로 삭제가능
        self.content.remove(at: indexPath.row)
        self.projectContent[self.currentPage].content[self.currentTitle] = self.content
        self.ref.child("\(email)/\(id)/content/\(currentPage)/\(currentTitle)").setValue(self.content)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

/// move cell
extension ProjectViewController: MoveContentDelegate {
    func moveContentTapButton(cell: UITableViewCell, tag: Int) {
        guard let indexPath = self.tableView.indexPath(for: cell) else {return}
        let title = self.content[indexPath.row] // 선택한 cell의 내용
        
        //tag가 1이면 left버튼, 현재페이지가 0이상일때만, content의 내용이 2개 이상일때만(내용이 1개만 있으면 cell을 삭제할경우 빈배열이 되어 db에 저장이 되지않는다.)
        if tag == 1, currentPage > 0, self.content.count > 1 {
            //현재 페이지의 content배열에서 삭제 -> projectcontent 배열에 저장 -> 바뀐 projectContent를 db에 저장
            self.content.remove(at: indexPath.row)
            self.projectContent[self.currentPage].content[self.currentTitle] = self.content
            self.ref.child("\(email)/\(id)/content/\(currentPage)/\(currentTitle)").setValue(self.content)
            
            //현재 페이지를 왼쪽으로 옮김 -> 옮긴페이지의 content값을 불러오고 그 content에 위에 삭제시킨 cell을 추가 -> 바뀐 content값을 projectContent에 저장 -> 테이블뷰 새로고침
            self.currentPage -= 1
            self.readContents()
            self.contentTitleLabel.text = self.currentTitle
            self.content.insert(title, at: 0)
            self.projectContent[self.currentPage].content[self.currentTitle] = self.content
            self.tableView.reloadData()
            self.ref.child("\(email)/\(id)/content/\(currentPage)/\(currentTitle)").setValue(self.content)
        }
        
        //tag가 2이면 right버튼, 현재페이지가 projectContent배열 갯수보다 작아야함
        if tag == 2, self.projectContent.count - 1 > currentPage, self.content.count > 1 {
            
            //현재 페이지의 content배열에서 삭제 -> projectcontent 배열에 저장 -> 바뀐 projectContent를 db에 저장
            self.content.remove(at: indexPath.row)
            self.projectContent[self.currentPage].content[self.currentTitle] = self.content
            self.ref.child("\(email)/\(id)/content/\(currentPage)/\(currentTitle)").setValue(self.content)
            
            self.currentPage += 1
            self.readContents()
            self.contentTitleLabel.text = self.currentTitle
            self.content.insert(title, at: 0)
            self.projectContent[self.currentPage].content[self.currentTitle] = self.content
            self.tableView.reloadData()
            self.ref.child("\(email)/\(id)/content/\(currentPage)/\(currentTitle)").setValue(self.content)
        }
    }
}

//detailContentView에서 보낸 값을 db에 저장하고 테이블 reload
extension ProjectViewController: SendContentDelegate {
    func sendContent(_ name: String, _ index: Int) {
        self.content[index] = name
        self.tableView.reloadRows(at: [[0,index]], with: .automatic)
        self.ref.child("\(email)/\(id)/content/\(currentPage)/\(currentTitle)").updateChildValues(["\(index)": name])
    }
}
