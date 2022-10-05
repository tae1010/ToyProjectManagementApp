//
//  ThirdTabbarViewController.swift
//  ToyProjectManagementApp
//
//  Created by 김정태 on 2022/04/13.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class MainTabbarViewController: UIViewController {

    //var projectList = [Project]()
    
    var projectListPrograssTrue = [Project]() // prograss가 true일때 section0에 저장
    var projectListPrograssFalse = [Project]() // prograss가 false일때 section1에 저장
    
    var ref: DatabaseReference! = Database.database().reference()

    var longPressCellIndex: Int? // longpress한 cell의 index
    var longPressCellSection: Int? // longpress한 cell의 section
    
    var email = " " // 사용자 id
    
    @IBOutlet weak var logoImageView: LogoImageView!
    @IBOutlet weak var logoLabel: LogoLabel!
    @IBOutlet weak var projectCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(deleteProjectNotification), name: .deleteProjectNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changePrograssProjectNotification), name: .changePrograssProjectNotification, object: nil)
        self.email = self.emailToString(Auth.auth().currentUser?.email ?? "고객")
        self.configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("mainttabbarview이동")
        self.readDB()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    //프로젝트 collection 추가
    @IBAction func addProjectButtonTap(_ sender: UIButton) {
        
        let createProjectPopup = CreateProjectPopupViewController(nibName: "CreateProjectPopup", bundle: nil)
        
        self.present(createProjectPopup, animated: true, completion: nil)
        
//        //alert창 생성 textfield, ok/cancel 버튼
//        let alert = UIAlertController(title: "프로젝트명", message: nil, preferredStyle: UIAlertController.Style.alert)
//
//        let okAction = UIAlertAction(title: "만들기", style: .default, handler: { [weak self] _ in
//            guard let self = self, let title = alert.textFields?[0].text else { return }
//            let id = UUID().uuidString
//            let email = self.emailToString(Auth.auth().currentUser?.email ?? "고객")
//            let project = Project(id: id, projectTitle: title, important: false, currentTime: self.koreanDate(), prograss: false)
//            self.projectListPrograssTrue.insert(project, at: 0)
//
//            //firebase에 데이터 입력
//            self.ref.child("\(email)/\(id)").updateChildValues(["important": false])
//            self.ref.child("\(email)/\(id)").updateChildValues(["projectTitle": title])
//            self.ref.child("\(email)/\(id)").updateChildValues(["currentTime": self.koreanDate()!])
//            self.ref.child("\(email)/\(id)").updateChildValues(["prograss": true])
//            self.ref.child("\(email)/\(id)/content/0/리스트 이름을 정해주세요/0").updateChildValues(["cardName": "카드를 추가해주세요", "color": "", "startTime": "", "endTime": ""])
//
//            DispatchQueue.main.async {
//                self.projectCollectionView.reloadData()
//            }
//        })
//
//        let cancelAction = UIAlertAction(title: "취소하기", style: .default, handler: nil)
//
//        alert.addTextField(configurationHandler: { textfield in
//            textfield.placeholder = "프로젝트명을 입력해주세요."
//        })
//
//        alert.addAction(okAction)
//        alert.addAction(cancelAction)
        
//        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func didLongPressCell(_ sender: UILongPressGestureRecognizer) {
        
        let longPressedPoint = sender.location(in: projectCollectionView)
        guard let indexPath = projectCollectionView.indexPathForItem(at: longPressedPoint)?.row else { return }
        guard let section = projectCollectionView.indexPathForItem(at: longPressedPoint)?.section else { return }
        
        self.longPressCellIndex = indexPath
        self.longPressCellSection = section
        
        let prograss = section == 0 ? projectListPrograssTrue[indexPath].prograss : projectListPrograssFalse[indexPath].prograss
        let projectTitle = section == 0 ? projectListPrograssTrue[indexPath].projectTitle : projectListPrograssFalse[indexPath].projectTitle
        
        switch sender.state {
        case .began:
            let projectPopup = ProjectPopupViewController(nibName: "projectCollectionViewPopup", bundle: nil)
            
            projectPopup.modalPresentationStyle = .overCurrentContext
            projectPopup.modalTransitionStyle = .crossDissolve // 뷰가 투명해지면서 넘어가는 애니메이션
            projectPopup.projectPrograss = prograss
            projectPopup.projectTitle = projectTitle
            self.present(projectPopup, animated: false, completion: nil)
            
        case .ended:
            print("ended", indexPath)
        default:
            // TODO animation
            break
        }
    }
}

// MARK: - function
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
        print(#fileID, #function, #line, "- readDB실행")
//        self.projectList.removeAll()
        self.projectListPrograssFalse.removeAll()
        self.projectListPrograssTrue.removeAll()

        ref.child(email).observeSingleEvent(of: .value, with: { snapshot in
          // Get user value
            guard let value = snapshot.value as? Dictionary<String, Any> else { return }
            
            for (key,val) in value {
                let id = key 
                guard let val = val as? Dictionary<String, Any> else { return }
                guard let projectTitle = val["projectTitle"] else { return }
                guard let important = val["important"] else { return }
                guard let currentTime = val["currentTime"] else { return }
                guard let prograss = val["prograss"] else { return }
                
                let pro = Project(id: id, projectTitle: projectTitle as! String, important: important as! Bool, currentTime: currentTime as! Int, prograss: prograss as! Bool)
                
                if pro.prograss {
                    self.projectListPrograssTrue.append(pro)
                } else {
                    self.projectListPrograssFalse.append(pro)
                }
//                self.projectList.append(pro)
            }
            
            // projectList section별 정렬
            self.sortFirstSection()
            self.sortSecondSection()
            
            DispatchQueue.main.async {
                self.projectCollectionView.reloadData()
            }
            
        }) { error in
          print(error.localizedDescription)
        }
    }
    
    // 메인화면에 보이는 collectionview projectList 정렬
    private func sortFirstSection() {
        
        var projectListImportantTrue = [Project]()
        var projectListImportantFalse = [Project]()
        
        // prograss가 true인 것중에서 important가 false인것만 저장
        projectListImportantFalse = self.projectListPrograssTrue.filter({
            $0.important == false
        })
        
        // prograss가 true인 것중에서 important가 true인것만 저장
        projectListImportantTrue = self.projectListPrograssTrue.filter({
            $0.important == true
        })
        
        projectListImportantFalse = projectListImportantFalse.sorted(by: {$0.currentTime > $1.currentTime})
        projectListImportantTrue = projectListImportantTrue.sorted(by: {$0.currentTime > $1.currentTime})
        
        self.projectListPrograssTrue = projectListImportantTrue + projectListImportantFalse
        
    }
    
    // section0,1에는 각각 현재 프로젝트 상황(prograss)이 false/ true 인것만 보여줌, 각각 날짜별로 정렬하되 important(즐겨찾기)가 true면 배열 앞으로 이동
    private func sortSecondSection() {
        
        var projectListImportantTrue = [Project]() // important가 true
        var projectListImportantFalse = [Project]() // important가 false

        // prograss가 false인 것중에서 important가 false인것만 저장
        projectListImportantFalse = self.projectListPrograssFalse.filter({
            $0.important == false
        })
        
        // prograss가 false인 것중에서 important가 true인것만 저장
        projectListImportantTrue = self.projectListPrograssFalse.filter({
            $0.important == true
        })
        
        projectListImportantFalse = projectListImportantFalse.sorted(by: {$0.currentTime > $1.currentTime})
        projectListImportantTrue = projectListImportantTrue.sorted(by: {$0.currentTime > $1.currentTime})
        
        self.projectListPrograssFalse = projectListImportantTrue + projectListImportantFalse
    }
    

    
    //db는 .을 저장할 수 없기때문에 이메일에 들어간 .를 ,으로 변환시켜주는 함수
    private func emailToString(_ email: String) -> String {
        let emailToString = email.replacingOccurrences(of: ".", with: ",")
        return emailToString
    }
    
    // 20200101111111 -> 2020-01-01
    private func changeDateLabel(indexPath: IndexPath) -> String {
        var dateText = indexPath.section == 0 ? String(self.projectListPrograssTrue[indexPath.row].currentTime) : String(self.projectListPrograssFalse[indexPath.row].currentTime)
        
        dateText.insert("-", at: dateText.index(dateText.startIndex, offsetBy: 4))
        dateText.insert("-", at: dateText.index(dateText.startIndex, offsetBy: 7))
        
        let result = String(dateText.dropLast(6))

        return result
    }
    
    // 팝업창 메뉴(tag)에 따른 기능 / tag1 : 정보보기, tag2 : 삭제하기
    private func deleteProject(index: Int, id: String, section: Int) {
        
        print(#fileID, #function, #line, "- 삭제하기 클릭")
        projectCollectionView.deleteItems(at: [[section, index]])
        self.ref.child("\(email)/\(id)/").removeValue()
        
        if section == 0 {
            self.projectListPrograssTrue.remove(at: index)
        } else {
            self.projectListPrograssFalse.remove(at: index)
        }
        
        DispatchQueue.main.async {
            self.projectCollectionView.reloadData()
        }
    }
    
    private func changePrograssProject(index: Int, id: String, section: Int, prograss: Bool) {
        
        print(#fileID, #function, #line, "- 변경하기 클릭")
        if section == 0 {
            self.projectListPrograssTrue[index].prograss = prograss
            self.ref.child("\(email)/\(id)").updateChildValues(["prograss": prograss])
            
            // projectListPrograssFalse에 projectListPrograssTrue에 있던 배열을 넣어주고 projectListPrograssTrue 인덱스 삭제
            self.projectListPrograssFalse.append(self.projectListPrograssTrue[index])
            self.projectListPrograssTrue.remove(at: index)
        } else {
            
            self.projectListPrograssFalse[index].prograss = prograss
            self.ref.child("\(email)/\(id)").updateChildValues(["prograss": prograss])
            
            self.projectListPrograssTrue.append(self.projectListPrograssFalse[index])
            self.projectListPrograssFalse.remove(at: index)
        }
        
        self.sortFirstSection()
        self.sortSecondSection()
        
        self.projectCollectionView.performBatchUpdates({
            self.projectCollectionView.reloadSections(NSIndexSet(index: section) as IndexSet)
        }, completion: { (finished:Bool) -> Void in })
    }
    
    //네비게이션뷰 숨기기, 컬렉션뷰 사이즈 생성해주는 함수
    private func configureView() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        self.projectCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.projectCollectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.projectCollectionView.delegate = self
        self.projectCollectionView.dataSource = self
        self.projectCollectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
    }
}

// MARK: - CollectionView delegate, datasource,
extension MainTabbarViewController: UICollectionViewDelegate {
    //셀 클릭시 작용
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let email = self.emailToString(Auth.auth().currentUser?.email ?? "고객")
        
        guard let projectViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProjectViewController") as? ProjectViewController else { return }
        projectViewController.email = email
        projectViewController.id = indexPath.section == 0 ? projectListPrograssTrue[indexPath.row].id : projectListPrograssFalse[indexPath.row].id
        projectViewController.projectTitle = indexPath.section == 0 ? projectListPrograssTrue[indexPath.row].projectTitle : projectListPrograssFalse[indexPath.row].projectTitle
        projectViewController.modalPresentationStyle = .fullScreen
        self.present(projectViewController, animated: false, completion: nil)
    }
}

extension MainTabbarViewController: UICollectionViewDataSource {
    
    // section 개수
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    // return section count
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return self.projectListPrograssTrue.count
        } else {
            return self.projectListPrograssFalse.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "projectSessionHeader", for: indexPath) as? ProjectCollectionReusableView{
            sectionHeader.sectionHeaderLabel.text = indexPath.section == 0 ? "진행중": "완료"
            sectionHeader.sectionHeaderLabel.font = UIFont(name: "NanumGothicOTFBold", size: 14)
            
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        // 진행중/ 완료 배열이 비워져있으면 header 높이를 0으로 값이 있으면 40
        if section == 0 {
            return self.projectListPrograssTrue.isEmpty ? CGSize(width: self.view.frame.width, height: 0) : CGSize(width: self.view.frame.width, height: 40)
        } else {
            return self.projectListPrograssFalse.isEmpty ? CGSize(width: self.view.frame.width, height: 0) : CGSize(width: self.view.frame.width, height: 40)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectCell", for: indexPath) as? ProjectCell else { return UICollectionViewCell() }
        
        // section0 prograss가 진행중(true)인것만 보여줌
        if indexPath.section == 0 {
            
            cell.importantImageView.tag = indexPath.row
            let importImageView = UITapGestureRecognizer(target: self, action: #selector(tabFirstSectionImageViewSelector))
            cell.importantImageView.addGestureRecognizer(importImageView)
            
            let projectListPrograssTrue = projectListPrograssTrue[indexPath.row]
            
            cell.projectTitleLabel.text = projectListPrograssTrue.projectTitle
            cell.dateLabel.text = self.changeDateLabel(indexPath: indexPath)
            cell.importantImageView.image = projectListPrograssTrue.important ? UIImage(named: "customStarfill") : UIImage(named: "customStar")
            
        // section1에는 prograss가 완료(false)인것만 보여줌
        } else if indexPath.section == 1 {
            
            cell.importantImageView.tag = indexPath.row
            let importImageView = UITapGestureRecognizer(target: self, action: #selector(tabSecondSectionImageViewSelector))
            cell.importantImageView.addGestureRecognizer(importImageView)
            
            let projectListPrograssFalse = projectListPrograssFalse[indexPath.row]
            
            cell.projectTitleLabel.text = projectListPrograssFalse.projectTitle
            cell.dateLabel.text = self.changeDateLabel(indexPath: indexPath)
            cell.importantImageView.image = projectListPrograssFalse.important ? UIImage(named: "customStarfill") : UIImage(named: "customStar")
            
        } else {
            return UICollectionViewCell()
        }
        
        cell.importantImageView.isUserInteractionEnabled = true
        
        return cell
    }
}

extension MainTabbarViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width / 2) - 20, height: (UIScreen.main.bounds.width / 2) - 80)
    }
}

// MARK: - selector
extension MainTabbarViewController {
    
    // 진행중 section에 있는 important image 클릭시 selector
    @objc func tabFirstSectionImageViewSelector(sender: UITapGestureRecognizer) {
        let imgView = sender.view as! UIImageView
        let index = imgView.tag // 클릭한 cell의 indexPath
        self.projectListPrograssTrue[index].important.toggle() // important 버튼을 클릭하면 true/ false가 바뀜
        
        // 바뀐 important값을 db에 저장
        self.ref.child("\(email)/\(self.projectListPrograssTrue[index].id)").updateChildValues(["important": self.projectListPrograssTrue[index].important])
        
        self.sortFirstSection()
        self.sortSecondSection()
        
        self.projectCollectionView.performBatchUpdates({
            self.projectCollectionView.reloadSections(NSIndexSet(index: 0) as IndexSet)
        }, completion: { (finished:Bool) -> Void in })

    }
    
    // 완료 section에 있는 important image 클릭시 selector
    @objc func tabSecondSectionImageViewSelector(sender: UITapGestureRecognizer) {
        let imgView = sender.view as! UIImageView
        let index = imgView.tag // 클릭한 cell의 indexPath
        self.projectListPrograssFalse[index].important.toggle() // important 버튼을 클릭하면 true/ false가 바뀜
        
        // 바뀐 important값을 db에 저장
        self.ref.child("\(email)/\(self.projectListPrograssFalse[index].id)").updateChildValues(["important": self.projectListPrograssFalse[index].important])
        
        self.sortFirstSection()
        self.sortSecondSection()
        
        self.projectCollectionView.performBatchUpdates({
            self.projectCollectionView.reloadSections(NSIndexSet(index: 1) as IndexSet)
        }, completion: { (finished:Bool) -> Void in })

    }
    
    @objc func deleteProjectNotification() {
        print(#fileID, #function, #line, "- deleteNotification")
        
        guard let index  = self.longPressCellIndex else { return }
        guard let section = self.longPressCellSection else { return }
        
        switch section {
        case 0:
            let id = self.projectListPrograssTrue[index].id
            self.deleteProject(index: index, id: id, section: section)
        case 1:
            let id = self.projectListPrograssFalse[index].id
            self.deleteProject(index: index, id: id, section: section)
        default:
            print("?")
        }
        
        DispatchQueue.main.async {
            self.projectCollectionView.reloadData()
        }
    }
    
    @objc func changePrograssProjectNotification(_ notification: Notification) {
        
        let getValue = notification.object as! Bool
        print(getValue)
        print(#fileID, #function, #line, "- changePrograssNotification")
        
        guard let index  = self.longPressCellIndex else { return }
        guard let section = self.longPressCellSection else { return }
        
        switch section {
        case 0:
            let id = self.projectListPrograssTrue[index].id
            
            // prograss가 바뀌었으면 chagnePrograssProject 실행
            if getValue != self.projectListPrograssTrue[index].prograss {
                self.changePrograssProject(index: index, id: id, section: section, prograss: getValue)
            }
        case 1:
            let id = self.projectListPrograssFalse[index].id
    
            // prograss가 바뀌었으면 chagnePrograssProject 실행
            if getValue != self.projectListPrograssFalse[index].prograss {
                self.changePrograssProject(index: index, id: id, section: section, prograss: getValue)
            }
            
        default:
            print("?")
        }
        
        
    }
}



