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
    var contents = [String]()
    
    var ref: DatabaseReference! = Database.database().reference()
    var id: String = ""
    var count: Int = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.readDB()
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let tableViewNib = UINib(nibName: "ProjectContentCell", bundle: nil)
        self.tableView.register(tableViewNib, forCellReuseIdentifier: "ProjectContentCell")
        
        
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
            self.contents.append(content)
            let pc = ProjectContent(id: self.id, count: self.count, contentTitle: "제목", content: self.contents)
            self.projectContent.append(pc)
            self.ref.child("\(email)/\(self.id)").updateChildValues(["contents": self.contents])
            print(self.contents)
            
            self.tableView.reloadData()
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
}

extension ProjectViewController {
    
    private func emailToString(_ email: String) -> String {
        let emailToString = email.replacingOccurrences(of: ".", with: ",")
        return emailToString
    }
    
    private func readDB() {
        let email = self.emailToString(Auth.auth().currentUser?.email ?? "고객")
        
        ref.child("\(email)/\(id)/contents").getData(completion:  { error, snapshot in
            guard error == nil else {
              print(error!.localizedDescription)
              return;
            }
            guard let content = snapshot.value as? [String] else { return }
            for con in content {
                self.contents.append(con)
            }
            print(self.contents)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
          });
        
    }
}

extension ProjectViewController: UITableViewDelegate {
    
}

extension ProjectViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectContentCell", for: indexPath) as! ProjectContentTableViewCell
        
        cell.content.text = contents[indexPath.row]

        return cell
    }
}
