//
//  ThirdTabbarViewController.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/04/13.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SideMenu

class MainTabbarViewController: UIViewController {
    
    var projectList = [Project]()
    
    var ref: DatabaseReference! = Database.database().reference()
    
    @IBOutlet weak var projectCollectionView: UICollectionView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        self.configureView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.readDB()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.projectList.removeAll()
    }
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
            let project = Project(id: id, user: emails, projectTitle: title, important: false, currentTime: self.koreanDate())
            self.projectList.insert(project, at: 0)
            
            //firebase에 데이터 입력
            self.ref.child("\(email)/\(id)").updateChildValues(["important": false])
            self.ref.child("\(email)/\(id)").updateChildValues(["projectTitle": title])
            self.ref.child("\(email)/\(id)").updateChildValues(["user": emails])
            self.ref.child("\(email)/\(id)").updateChildValues(["currentTime": self.koreanDate()!])
            
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
    
}

extension MainTabbarViewController {
    
    //현재 시간을 int값으로 반환시켜주는 함수
    private func koreanDate() -> Int!{
        let current = Date()
        
        let formatter = DateFormatter()
        //한국 시간으로 표시
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        //형태 변환
        formatter.dateFormat = "yyyyMMddHHmmss"
        
        return Int(formatter.string(from: current))
    }
    
    //db값을 읽어서 projectList에 db값을 넣어준 뒤 collectionview 업데이트 해주는 함수
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
                guard let currentTime = val["currentTime"] else { return }
                
                let pro = Project(id: id, user: users as! [String], projectTitle: projectTitle as! String, important: important as! Bool, currentTime: currentTime as! Int)
                print(pro)
                self.projectList.append(pro)
            }
            //날짜 순서대로 정렬
            self.projectList = self.projectList.sorted(by: {$0.currentTime > $1.currentTime})
            
            print(self.projectList)
            DispatchQueue.main.async {
                self.projectCollectionView.reloadData()
            }
            
        }) { error in
          print(error.localizedDescription)
        }
    }
    
    //db는 .을 저장할 수 없기때문에 이메일에 들어간 .를 ,으로 변환시켜주는 함수
    private func emailToString(_ email: String) -> String {
        let emailToString = email.replacingOccurrences(of: ".", with: ",")
        return emailToString
    }
    
    //네비게이션뷰 숨기기, 컬렉션뷰 사이즈 생성해주는 함수
    private func configureView() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        self.projectCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.projectCollectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.projectCollectionView.delegate = self
        self.projectCollectionView.dataSource = self
    }
}

extension MainTabbarViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let email = self.emailToString(Auth.auth().currentUser?.email ?? "고객")
        
        guard let projectViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProjectViewController") as? ProjectViewController else { return }
        projectViewController.email = email
        projectViewController.id = projectList[indexPath.row].id
        projectViewController.modalPresentationStyle = .fullScreen
        self.present(projectViewController, animated: false, completion: nil)
    }
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
