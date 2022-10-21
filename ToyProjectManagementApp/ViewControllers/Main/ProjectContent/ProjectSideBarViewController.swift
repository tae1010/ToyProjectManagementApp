//
//  ListSideBarViewController.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/08/01.
//

import UIKit

//sidebar에서 리스트 이름을 클릭하면 그페이지로 이동시키는 delegate
protocol MoveListDelegate: AnyObject {
    func moveListDelegate(index: IndexPath)
}

protocol ChangeListDelegate: AnyObject {
    func changeListDelegate(index: IndexPath)
}

protocol DeleteListDelegate: AnyObject {
    func deleteListDelegate(index: IndexPath)
}

class ProjectSideBarViewController: UIViewController {
    
    var sectionHeader = [String]()
    var listName = [String]()
    var projectTitle: String = ""
    var currentPage: Int = 0
    var clickCellIndexPath: IndexPath?
    
    weak var moveListDelegate: MoveListDelegate?
    weak var changeListDelegate: ChangeListDelegate?
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
    
    @IBAction func tapMoveListButton(_ sender: Any) {
        guard let clickCellIndexPath = self.clickCellIndexPath else { return }
        print(clickCellIndexPath,"흐으음?")
        self.moveListDelegate?.moveListDelegate(index: clickCellIndexPath)
        dismiss(animated: true)
    }
    
    @IBAction func tapChangeListTitleButton(_ sender: UIButton) {
        guard let clickCellIndexPath = self.clickCellIndexPath else { return }
        self.changeListDelegate?.changeListDelegate(index: clickCellIndexPath)
        dismiss(animated: true)
    }
    
    @IBAction func tapDeleteListButton(_ sender: UIButton) {
        guard let clickCellIndexPath = self.clickCellIndexPath else { return }
        self.deleteListDelegate?.deleteListDelegate(index: clickCellIndexPath)
        dismiss(animated: true)
    }
    
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

extension ProjectSideBarViewController: UITableViewDelegate {
    
}

extension ProjectSideBarViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectContentSideBar", for: indexPath) as! ProjectSideBarTableViewCell
        cell.selectionStyle = .none
        cell.sideBarList.text = listName[indexPath.row]
        cell.currentPageCheckImageView.isHidden = currentPage == indexPath.row ? false : true
        cell.selectImageView.isHidden = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.clickCellIndexPath = indexPath
        self.view.makeToast("\(listName[indexPath.row])", duration: 0.5)
    }
    
}
