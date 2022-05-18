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
    
    var projectContent = [ProjectContent]()
    
    var ref: DatabaseReference! = Database.database().reference()
    var id: String = ""
    var currentCount: Int = 0 //현재 페이지
    var contentTitle: String?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.readDB()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let tableViewNib = UINib(nibName: "ProjectContentCell", bundle: nil)
        self.tableView.register(tableViewNib, forCellReuseIdentifier: "ProjectContentCell")
        
        print(self.projectContent)
    }
    
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
        }
    }
    
    @IBAction func moveRight(_ sender: UIButton) {
        if maxCount >= currentCount {
            self.currentCount += 1
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
                //몇번째 인덱스인지?
                guard let count = value.firstIndex(of: content) else { return }
                print(count)
                let pc = ProjectContent(id: self.id, count: count, content: content)
                print(pc)
                self.projectContent.append(pc)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }) { error in
          print(error.localizedDescription)
        }
    }
}

extension ProjectViewController: UITableViewDelegate {
    
}

extension ProjectViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //첫번쨰 배열에 배열 갯수
        return self.projectContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectContentCell", for: indexPath) as! ProjectContentTableViewCell
        let projectContent = projectContent[indexPath.row].content
        
//        struct ProjectContent {
//            var id: String // Project 구조체에 있는 id 저장
//            var count: Int // 몇번째 배열인지 저장하는함수
//            var content: Dictionary<String, [String]> // title과 content들을 저장할 dictionary
//        }
//        if projectContent.count == currentCount {
//            for (key,value) in projectContent.content{
//                self.contentTitle = key
//                cell.content.text = value.first
//            }
//        }
        print(projectContent)
        cell.leftInset = 20
        cell.rightInset = 20

        return cell
    }
}
