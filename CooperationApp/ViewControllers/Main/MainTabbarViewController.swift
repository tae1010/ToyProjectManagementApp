//
//  ThirdTabbarViewController.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/04/13.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

var projectList = [Project]()

class MainTabbarViewController: UIViewController {
    
    let parentDB = "https://cooperationapp-4acb9-default-rtdb.firebaseio.com/"
    var ref: DatabaseReference! = Database.database().reference()
    
    @IBOutlet weak var projectCollectionView: UICollectionView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        self.readDB()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    //db값을 읽어서 projectList에 db값을 넣어준 뒤 collectionview 업데이트
    private func readDB() {
        let email = self.emailToString(Auth.auth().currentUser?.email ?? "고객")
        
        ref.child(email).observeSingleEvent(of: .value, with: { snapshot in
          // Get user value
            guard let value = snapshot.value as? Dictionary<String, Any> else {return}
            for (key,val) in value {
                let id = key
                guard let val = val as? Dictionary<String, Any> else { return }
                guard let projectTitle = val["projectTitle"] else { return }
                guard let important = val["important"] else { return }
                guard let users = val["user"] else { return }
                
                let pro = Project(id: id , user: users as! [String], projectTitle: projectTitle as! String , important: important as! Bool)
                projectList.append(pro)
                
                DispatchQueue.main.async {
                    self.projectCollectionView.reloadData()
                }
            }
            

          // ...
        }) { error in
          print(error.localizedDescription)
        }
    }
            
            
            
//            for child in snapshot.children {
//                // Get user value
//                let snap = child as! DataSnapshot
//                let id = snap.key
//                for key in snap.key {
//                    print(key.important)
//                }
                

//                let id = value?["id"] as? String ?? ""
//                let important = value?["important"] as? Bool ?? false
//                let projectTitle = value?["projectTitle"] as? String ?? ""
//                var emails = [String]()
//
//                emails.append(email)
//                let project = Project(id: id, user: emails, projectTitle: projectTitle, important: important)
//                projectList.append(project)
//                print(projectList)
            //}
//        }) { error in
//            print(error.localizedDescription)
//        }
//    }
    
    
    
    
    //프로젝트 collection 추가
    @IBAction func addProjectButtonTap(_ sender: UIButton) {
        //alert창 생성 textfield, ok/cancel 버튼
        let alert = UIAlertController(title: "프로젝트명", message: nil, preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "만들기", style: .default, handler: { [weak self] _ in
            guard let self = self,
                  let title = alert.textFields?[0].text else { return }
            let id = UUID().uuidString
            var emails = [String]()
            let email = self.emailToString(Auth.auth().currentUser?.email ?? "고객")
            emails.append(email)
            let project = Project(id: id, user: emails, projectTitle: title, important: false)
            projectList.append(project)
            
            //firebase에 데이터 입력
            self.ref.child("\(email)/\(id)").updateChildValues(["important": false])
            self.ref.child("\(email)/\(id)").updateChildValues(["projectTitle": title])
            self.ref.child("\(email)/\(id)").updateChildValues(["user": emails])
            
            DispatchQueue.main.async {
                self.projectCollectionView.reloadData()
            }
            
        })
        
        let cancelAction = UIAlertAction(title: "취소하기", style: .default, handler: nil)
        
        alert.addTextField(configurationHandler: { textfield in
            textfield.placeholder = "프로젝트명을 입력해주세요."
        })
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //db는 .을 저장할 수 없기때문에 이메일에 들어간 .를 ,으로 변환시켜주는 함수
    private func emailToString(_ email: String) -> String {
        let emailToString = email.replacingOccurrences(of: ".", with: ",")
        return emailToString
    }
    
    //네비게이션뷰 숨기기, 컬렉션뷰 사이즈 생성
    private func configureView() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        self.projectCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.projectCollectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.projectCollectionView.delegate = self
        self.projectCollectionView.dataSource = self
    }
}

extension MainTabbarViewController: UICollectionViewDelegate {
    
}

extension MainTabbarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return projectList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectCell", for: indexPath) as? ProjectCell else { return UICollectionViewCell() }
        
        let project = projectList[indexPath.row]
        cell.projectTitleLabel.text = project.projectTitle
        cell.userLabel.text = project.user.first
        return cell
    }
}

extension MainTabbarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width / 2) - 20, height: 140)
    }
}
