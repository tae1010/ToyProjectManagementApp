//
//  ListSideBarViewController.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/08/01.
//

import UIKit
import FirebaseDatabase
import MaterialComponents.MaterialBottomSheet
import Toast_Swift

//sidebar에서 리스트 이름을 클릭하면 그페이지로 이동시키는 delegate
protocol MoveListDelegate: AnyObject {
    func moveListDelegate(index: IndexPath)
}

protocol DeleteListDelegate: AnyObject {
    func deleteListDelegate(index: IndexPath)
}

class ProjectListManagementViewController: UIViewController {
    
    var projectContent = [ProjectContent]()
    var email = ""
    var id = ""
    
    var listName = [String]()
    var projectTitle: String = ""
    var currentPage: Int = 0
    var clickCellIndexPath: IndexPath?
    var ref: DatabaseReference! = Database.database().reference() // realtime DB
    
    weak var moveListDelegate: MoveListDelegate?
    weak var deleteListDelegate: DeleteListDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sideBarTableView: UITableView!
    
    @IBOutlet weak var moveListButton: UIButton!
    @IBOutlet weak var changeListTitleButton: UIButton!
    @IBOutlet weak var deleteListButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTitleLabel()
        self.configureButton()
        
        sideBarTableView.dataSource = self
        sideBarTableView.delegate = self
        let tableViewNib = UINib(nibName: "ProjectContentSideBar", bundle: nil)
        self.sideBarTableView.register(tableViewNib, forCellReuseIdentifier: "ProjectContentSideBar")
    }

    @IBAction func tapBackButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    // 원하는 리스트 페이지로 이동
    @IBAction func tapMoveListButton(_ sender: Any) {

        guard let clickCellIndexPath = self.clickCellIndexPath else {
            self.view.makeToast("리스트를 선택해주세요")
            return
        }
        
        self.moveListDelegate?.moveListDelegate(index: clickCellIndexPath)
        dismiss(animated: true)
    }
    
    // 리스트 이름 변경
    @IBAction func tapChangeListTitleButton(_ sender: UIButton) {
        
        guard let clickCellIndexPath = self.clickCellIndexPath else {
            self.view.makeToast("리스트를 선택해주세요")
            return
        }
        
        let changeListPopup = ChangeListTitlePopupViewController(nibName: "ChangeListTitlePopup", bundle: nil)
        
        changeListPopup.view.clipsToBounds = false
        changeListPopup.view.layer.cornerRadius = 20
        changeListPopup.clickListTitle = clickCellIndexPath
        changeListPopup.changeListTitleDelegate = self
        
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: changeListPopup)
        bottomSheet.mdc_bottomSheetPresentationController?.preferredSheetHeight = self.view.bounds.size.height * 0.3
        
        self.present(bottomSheet, animated: false, completion: nil)
    }
    
    // 리스트 삭제
    @IBAction func tapDeleteListButton(_ sender: UIButton) {
        
        guard let clickCellIndexPath = self.clickCellIndexPath else { return }
        
        self.deleteListDelegate?.deleteListDelegate(index: clickCellIndexPath)
        dismiss(animated: true)
    }

}

// MARK: - configure
extension ProjectListManagementViewController {
    
    private func configureTitleLabel() {
        self.titleLabel.font = UIFont(name: "NanumGothicOTFBold", size: 28)
    }
    
    private func configureButton() {
        
        self.moveListButton.layer.cornerRadius = 8
        self.changeListTitleButton.layer.cornerRadius = 8
        self.deleteListButton.layer.cornerRadius = 8
        
        [self.moveListButton, self.changeListTitleButton, self.deleteListButton].forEach({
            $0?.titleLabel?.font = UIFont(name: "NanumGothicOTF", size: 15)
        })
    }
}

extension ProjectListManagementViewController: UITableViewDelegate {
    
}

extension ProjectListManagementViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectContentSideBar", for: indexPath) as! ProjectListManagementCell
        cell.selectionStyle = .none
        cell.listTitle.text = listName[indexPath.row]
        cell.currentPageCheckImageView.isHidden = currentPage == indexPath.row ? false : true
        cell.selectImageView.isHidden = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.clickCellIndexPath = indexPath
        self.view.makeToast("\(listName[indexPath.row])", duration: 0.5)
    }
    
}

extension ProjectListManagementViewController: ChangeListTitleDelegate {
    func changeListTitleDelegate(index: IndexPath, listTitle: String) {
        
        self.listName[index.row] = listTitle
        self.projectContent[index.row].listTitle = listTitle
        
        var count = 0

        // 변경된 db내용 삭제
        self.ref.child("\(email)/\(id)/content/\(index.row)").removeValue()

        // 변경된 내용 db저장
        for i in self.projectContent[index.row].detailContent {

            let cardName = i.cardName
            let color = i.color
            let startTime = i.startTime
            let endTime = i.endTime

            let detailContent = ["cardName": cardName, "color": color, "startTime": startTime, "endTime": endTime]
            let detailContentModel = ProjectDetailContent(cardName: cardName, color: color, startTime: startTime, endTime: endTime)

            self.ref.child("\(email)/\(id)/content/\(index.row)/\(listTitle)/\(count)").setValue(detailContent)

            count += 1
        }
        
        DispatchQueue.main.async {
            self.sideBarTableView.reloadData()

        }
    }
    
}
