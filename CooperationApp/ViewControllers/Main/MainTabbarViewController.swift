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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        
        self.readDB()

    }
    
    private func readDB() {
        let email = self.emailToString(Auth.auth().currentUser?.email ?? "고객")
        
        ref.child(email).observeSingleEvent(of: .value, with: { [ weak self ] snapshot in
          // Get user value
            guard let self = self else { return }
            let value = snapshot.value as? NSDictionary
            
            let id = value?["id"] as? String ?? ""
            let important = value?["important"] as? Bool ?? false
            let projectTitle = value?["projectTitle"] as? String ?? ""
            var emails = [String]()
            
            emails.append(email)
            let project = Project(id: id, user: emails, projectTitle: projectTitle, important: important)
            projectList.append(project)
            
            self.projectCollectionView.reloadData()
          // ...
        }) { error in
          print(error.localizedDescription)
        }
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
            let project = Project(id: id, user: emails, projectTitle: title, important: false)
            projectList.append(project)
            
            //firebase에 데이터 입력
            self.ref.child(email).updateChildValues(["user": emails])
            self.ref.child(email).updateChildValues(["important": false])
            self.ref.child(email).updateChildValues(["projectTitle": title])
            self.ref.child(email).updateChildValues(["id": id])
            
            self.projectCollectionView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "취소하기", style: .default, handler: nil)
        
        alert.addTextField(configurationHandler: { textfield in
            textfield.placeholder = "프로젝트명을 입력해주세요."
        })
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //db는 @를 저장할 수 없기때문에 이메일에 들어간 @를 #으로 변환시켜주는 함수
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

extension String {
    // [정규식 수행 실시 : 사용 방법 : let changeData = strData.matchString(_string: strData)]
    func matchString (_string : String) -> String { // 문자열 변경 실시
        let strArr = Array(_string) // 문자열 한글자씩 확인을 위해 배열에 담는다
        
        let pattern = "^[ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9]$" // 정규식 : 한글, 영어, 숫자만 허용 (공백, 특수문자 제거)
        //let pattern = "^[ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9\\s]$" // 정규식 : 한글, 영어, 숫자, 공백만 허용 (특수문자 제거)
        
        // 문자열 길이가 한개 이상인 경우만 패턴 검사 수행
        var resultString = ""
        if strArr.count > 0 {
            if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
                var index = 0
                while index < strArr.count { // string 문자 하나 마다 개별 정규식 체크
                    let checkString = regex.matches(in: String(strArr[index]), options: [], range: NSRange(location: 0, length: 1))
                    if checkString.count == 0 {
                        index += 1 // 정규식 패턴 외의 문자가 포함된 경우
                    }
                    else { // 정규식 포함 패턴의 문자
                        resultString += String(strArr[index]) // 리턴 문자열에 추가
                        index += 1
                    }
                }
            }
            return resultString
        }
        else {
            return _string // 원본 문자 다시 리턴
        }
    }
}
