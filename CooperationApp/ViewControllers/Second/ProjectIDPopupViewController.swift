//
//  ProjectIDPopupViewController.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/08/23.
//

import UIKit

protocol SelectIdDelegate: AnyObject {
    func sendId(_ id: String)
}

class ProjectIDPopupViewController: UIViewController {
    
    var projectId = [ProjectID]()
    weak var selectIdDelegate: SelectIdDelegate?

    @IBOutlet var backGroundView: UIView!
    @IBOutlet weak var projectIDCollectionView: UICollectionView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var popUpViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //popupview height 오토레이아웃 설정
        self.popUpViewHeight.constant = projectId.count < 5 ? CGFloat(projectId.count * 50) : 250
        self.projectIDCollectionView.delegate = self
        self.projectIDCollectionView.dataSource = self
        self.projectIDCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
        let projectIDCellNib = UINib(nibName: "ProjectIDCell", bundle: nil)
        self.projectIDCollectionView.register(projectIDCellNib, forCellWithReuseIdentifier: "ProjectIDCell")
        
//        let tabBackGroundView = UITapGestureRecognizer(target: self, action: #selector(tabBackGroundSelector))
//        self.backGroundView.addGestureRecognizer(tabBackGroundView)
//        self.backGroundView.isUserInteractionEnabled = true
    }

    //백 그라운드 클릭시 팝업창 닫기
//    @objc func tabBackGroundSelector(sender: UITapGestureRecognizer) {
//        print("background view 선택")
//        self.dismiss(animated: true)
//    }
}
    

extension ProjectIDPopupViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("실행됨")
        print(projectId[indexPath.row].projectid,"afafaf")
        self.selectIdDelegate?.sendId(projectId[indexPath.row].projectid)
        self.dismiss(animated: true)
    }
}

extension ProjectIDPopupViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return projectId.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let projectIDCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectIDCell", for: indexPath) as? ProjectIDCollectionViewCell else { return UICollectionViewCell() }
        projectIDCell.projectID.text = projectId[indexPath.row].projectTitle
        
        return projectIDCell
    }

}

extension ProjectIDPopupViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = projectIDCollectionView.frame.width
        let height = 40.0
        
        return CGSize(width: width, height: height)
    }
    
}

