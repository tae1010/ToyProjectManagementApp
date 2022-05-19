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
            //self.contents[self.currentCount].append(content)
            //let pc = ProjectContent(id: self.id, contentTitle: "제목", content: content)
            //self.projectContent.append(pc)
            //self.ref.child("\(email)/\(self.id)/content").updateChildValues(["contents\(String(self.currentCount))": self.contents])
            //print(self.contents)
            
            //self.tableView.reloadData()
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
                // content는 ["contents0": ["123","234","123"]] ["contents1": ["11", "2323"]]
                // content배열에서 몇번째 배열인지 ProjectContent.count에 저장
                guard let count = value.firstIndex(of: content) else { return }
                let pc = ProjectContent(id: self.id, countIndex: count, content: content)
                self.projectContent.append(pc)
                
            }
            //self.projectContent
            //[CooperationApp.ProjectContent(id: "4CCE18B9-88F2-4C4C-AB22-C6F74E74FF3F", count: 0, content: ["contents0": ["123", "234", "123"]]),
            //CooperationApp.ProjectContent(id: "4CCE18B9-88F2-4C4C-AB22-C6F74E74FF3F", count: 1, content: ["contents1": ["11", "2323"]])]
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            print("readDB완료")
            self.readContents()
            
        }) { error in
          print(error.localizedDescription)
        }
    }
    
    //readDB에서 저장시킨 projectContent모델에서 현재 페이지의 content.value값을 저장시키는 함수
    private func readContents() {
        for pc in self.projectContent{
            if pc.countIndex == currentCount {
                //2차원 배열을 1차원으로 바꿔줌
                self.content = Array(pc.content.values.joined())
            }
        }
    }
    
}

extension ProjectViewController: UITableViewDelegate {
    
}

extension ProjectViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectContentCell", for: indexPath) as! ProjectContentTableViewCell
        
        cell.content.text = self.content[indexPath.row]

        cell.leftInset = 20
        cell.rightInset = 20

        return cell
    }
}
