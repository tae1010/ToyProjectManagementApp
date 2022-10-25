//
//  ProjectContentViewController+Delegate.swift
//  ToyProjectManagementApp
//
//  Created by 김정태 on 2022/10/20.
//

import Foundation
import UIKit
import SideMenu

// MARK: - currentPage이동
extension ProjectContentViewController: MoveListDelegate {
    func moveListDelegate(index: IndexPath) {
        
        self.currentPage = index.row
        
        DispatchQueue.main.async {
            self.cardTableView.reloadData()
        }
    }
}

// MARK: - 리스트 삭제
extension ProjectContentViewController: DeleteListDelegate {
    
    func deleteListDelegate(index: IndexPath) {
        
    }

}

// MARK: - projectContentVC에서 dropdown으로 카드 이동
extension ProjectContentViewController: MoveContentDelegate {
    // cell : cell more button / listIndex: 선택된 dropdown
    func moveContentTapButton(cell: UITableViewCell, listIndex: Int) {
        if currentPage == listIndex {
            self.view.makeToast("카드는 이미 리스트안에 있습니다",duration: 1.5)
            return
        }
        
        var count = 0
        
        // 선택된 section
        guard let cellIndexPath = self.cardTableView.indexPath(for: cell)?.section else { return }
        
        // 선택된 section card
        let selectCell = self.projectContent[self.currentPage].detailContent[cellIndexPath]
        
        // card 삭제
        self.projectContent[self.currentPage].detailContent.remove(at: cellIndexPath)
        
        // 배열 순서를 위해 db에 detailContent 다시저장
        self.ref.child("\(email)/\(id)/content/\(currentPage)/\(self.currentTitle)").removeValue()
        for i in self.projectContent[self.currentPage].detailContent {
            let cardName = i.cardName ?? ""
            let color = i.color ?? ""
            let startTime = i.startTime ?? ""
            let endTime = i.endTime ?? ""
            
            self.ref.child("\(email)/\(id)/content/\(currentPage)/\(currentTitle)/\(count)").setValue(["cardName": cardName, "color": color, "startTime": startTime, "endTime": endTime])
            count += 1
        }
        
        self.currentPage = listIndex
        self.changeListName()
        self.projectContent[self.currentPage].detailContent.insert(selectCell, at: 0)
        self.cardTableView.reloadData()
        
        count = 0
        self.ref.child("\(email)/\(id)/content/\(currentPage)/\(self.currentTitle)").removeValue()
        for i in self.projectContent[self.currentPage].detailContent {
            
            let cardName = i.cardName ?? ""
            let color = i.color ?? ""
            let startTime = i.startTime ?? ""
            let endTime = i.endTime ?? ""
            
            self.ref.child("\(email)/\(id)/content/\(currentPage)/\(currentTitle)/\(count)").setValue(["cardName": cardName, "color": color, "startTime": startTime, "endTime": endTime])
            count += 1
        }
        self.view.makeToast("카드가 이동되었습니다", duration: 1.5)
            
    }
}


// detailContentView에서 보낸 값을 db에 저장하고 테이블 reload
extension ProjectContentViewController: SendContentDelegate {
    func sendContent(_ name: String, _ index: Int, _ color: String, _ startTime: String, _ endTime: String) {
        
        // realtime DB작성
        self.projectContent[self.currentPage].detailContent[index].cardName = name
        self.projectContent[self.currentPage].detailContent[index].startTime = startTime
        self.projectContent[self.currentPage].detailContent[index].endTime = endTime
        self.projectContent[self.currentPage].detailContent[index].color = color
        
        self.cardTableView.reloadRows(at: [[index,0]], with: .automatic) // 선택된 cell 갱신
        self.ref.child("\(email)/\(id)/content/\(currentPage)/\(currentTitle)/\(index)").updateChildValues(["cardName": name, "color": color, "startTime": startTime, "endTime": endTime])
        
        // firestore DB작성
        
        
    }
}

// card 지우기
extension ProjectContentViewController: DeleteCellDelegate {
    func sendCellIndex(_ index: IndexPath) {
        self.deleteCell(index.section)
        
        DispatchQueue.main.async {
            self.cardTableView.deleteRows(at: [index], with: .automatic)
        }
    }
}

//extension ProjectContentViewController: SendPageDelegate {
//    func sendPage(_ index: IndexPath) {
//        self.currentPage = index.section
//        
//        DispatchQueue.main.async {
//            self.changeListName()
//            self.cardTableView.reloadData()
//        }
//    }
//}

extension ProjectContentViewController: MakeToastMessage {
    
    func makeToastMessage() {
        self.view.makeToast("이동하고 싶은 리스트를 선택하세요")
    }
}


extension ProjectContentViewController: SideMenuNavigationControllerDelegate {

    func sideMenuWillAppear(menu: SideMenuNavigationController, animated: Bool) {
        print("willAppear")
    }

    func sideMenuDidAppear(menu: SideMenuNavigationController, animated: Bool) {

    }

    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
    }

    func sideMenuDidDisappear(menu: SideMenuNavigationController, animated: Bool) {

    }
}
