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
    let sqlite = SQlite.shared
    var ref: DatabaseReference!
    
    @IBOutlet weak var projectCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        
        ref = Database.database().reference()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    //프로젝트 collection 추가
    @IBAction func addProjectButtonTap(_ sender: UIButton) {
        //alert창 생성 textfield, ok/cancel 버튼
        let alert = UIAlertController(title: "프로젝트명", message: nil, preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "만들기", style: .default, handler: { [weak self] _ in
            guard let title = alert.textFields?[0].text else { return }
            var emails = [String]()
            let email = Auth.auth().currentUser?.email ?? "고객"
            emails.append(email)
            let project = Project(user: emails, projectTitle: title, important: false)
            projectList.append(project)
            self?.projectCollectionView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "취소하기", style: .default, handler: nil)
        
        alert.addTextField(configurationHandler: { textfield in
            textfield.placeholder = "프로젝트명을 입력해주세요."
        })
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
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
