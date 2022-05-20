//
//  ProjectViewController.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/05/11.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProjectViewController: UIViewController {
    
    var projectContent = [ProjectContent]() // project model 배열
    var content = [String]() //projectcontent model의 content.value값을 저장
    
    var ref: DatabaseReference! = Database.database().reference()
    var id: String = "" // 프로젝트의 uuid값을 받을 변수
    var currentCount: Int = 0 //현재 페이지
    var currentTitle: String = "이름없음"
    
    @IBOutlet weak var contentTitleLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidLoad() {
        print("viewdidload시작")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let tableViewNib = UINib(nibName: "ProjectContentCell", bundle: nil)
        self.tableView.register(tableViewNib, forCellReuseIdentifier: "ProjectContentCell")
        self.readDB()
        print(self.currentCount)
        
    }
    
    //뒤로가기 버튼(Maintabbarview로 돌아감)
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: false)
    }
    
    @IBAction func addTableView(_ sender: UIButton) {
        let email = self.emailToString(Auth.auth().currentUser?.email ?? "고객")
        let alert = UIAlertController(title: "내용추가", message: nil, preferredStyle: .alert)
        //alert 등록버튼
        let registerButton = UIAlertAction(title: "추가", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            guard let content = alert.textFields?[0].text else { return }
            // 경로중 self.content.count라고 안하고 "\(self.content.count)" 라고 작성한 이유는 경로를 찾을때는 string값만 허용
            self.ref.child("\(email)/\(self.id)/content/\(self.currentCount)/\(self.currentTitle)").updateChildValues(["\(self.content.count)": content])
            
            self.content.append(content)
            
            DispatchQueue.main.async {
                self.readDB()
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
    
    @IBAction func moveLeft(_ sender: UIButton) {
        if currentCount > 0 {
            self.currentCount -= 1
            self.readContents()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            print(self.currentCount)
        }
    }
    
    @IBAction func moveRight(_ sender: UIButton) {
        if self.projectContent.count - 1 > currentCount {

            self.currentCount += 1
            DispatchQueue.main.async {
                self.readContents()
                self.tableView.reloadData()
            }
            print(currentCount)
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
                self.tableView.reloadData()
            }

        }) { error in
          print(error.localizedDescription)
        }
    }
    
    //readDB에서 저장시킨 projectContent모델에서 현재 페이지의 content.value(content의 내용)값과 content.key(content의 title)를 저장시키는 함수
    private func readContents() {
        for pc in self.projectContent{
            if pc.countIndex == currentCount {
                //2차원 배열을 1차원으로 바꿔줌
                self.currentTitle = pc.content.keys.joined(separator: "")
                self.content = Array(pc.content.values.joined())
            }
        }
        self.contentTitleLabel.text = self.currentTitle
    }
    
}

extension ProjectViewController: UITableViewDelegate {
    
}

extension ProjectViewController: UITableViewDataSource {
    //content의 배열 인덱스 갯수 만큼 return
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectContentCell", for: indexPath) as! ProjectContentTableViewCell
        cell.content.text = self.content[indexPath.row]
        return cell
    }
}
