//
//  ListSideBarViewController.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/08/01.
//

import UIKit

//sidebar에서 리스트 이름을 클릭하면 그페이지로 이동시키는 delegate
protocol SendPageDelegate: AnyObject {
    func sendPage(_ index: IndexPath)
}

class ProjectSideBarViewController: UIViewController {
    
    var sectionHeader = [String]()
    var listName = [String]()
    var listFunc = ["리스트 추가"]
    var projectTitle: String = ""
    
    weak var sendPageDelegate: SendPageDelegate?

    @IBOutlet weak var sideBarTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sectionHeader.append(projectTitle)
        self.sectionHeader.append(" ")
        self.navigationController?.isNavigationBarHidden = true
        
        sideBarTableView.dataSource = self
        sideBarTableView.delegate = self
        let tableViewNib = UINib(nibName: "ProjectContentSideBar", bundle: nil)
        self.sideBarTableView.register(tableViewNib, forCellReuseIdentifier: "ProjectContentSideBar")
        
        
    }

}

extension ProjectSideBarViewController: UITableViewDelegate {
    
}

extension ProjectSideBarViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return listName.count
        } else if section == 1 {
            return listFunc.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectContentSideBar", for: indexPath) as! ProjectSideBarTableViewCell
        
        if indexPath.section == 0 {
            cell.sideBarList.text = listName[indexPath.row]
        } else if indexPath.section == 1 {
            cell.sideBarList.text = listFunc[indexPath.row]
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeader.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeader[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sendPageDelegate?.sendPage(indexPath)
        print(indexPath,"됐다")
        dismiss(animated: true)
    }
}
