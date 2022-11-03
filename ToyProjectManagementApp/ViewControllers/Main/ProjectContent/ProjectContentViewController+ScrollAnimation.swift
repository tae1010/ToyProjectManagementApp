//
//  ProjectContentViewController+ScrollAnimation.swift
//  ToyProjectManagementApp
//
//  Created by 김정태 on 2022/10/17.
//

import Foundation
import UIKit

let stretchedHeight: CGFloat = 230.0
let huggedHeight: CGFloat = 120.0
let bgHeight: CGFloat = 350.0

extension ProjectContentViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let headerStretchedHeight = stretchedHeight
        let headerHuggedHeight = huggedHeight
        let headerBGStretchedHeight = bgHeight

        let offsetY = scrollView.contentOffset.y
        let newHeight = headerViewHeightAnchor.constant - offsetY
        
        // change height of header view and header background view
        headerViewHeightAnchor.constant = newHeight
        let backgroundOffsetDiff = headerBGStretchedHeight * (-offsetY) / headerStretchedHeight
        let backgroundNewHeight = stickyHeaderViewHeightAnchor.constant + backgroundOffsetDiff
        stickyHeaderViewHeightAnchor.constant = backgroundNewHeight
        
        if headerViewHeightAnchor.constant >= headerStretchedHeight {
            headerViewHeightAnchor.constant = headerStretchedHeight
            UIView.animateCurveEaseOut(withDuration: 0.2, animations: {
                self.normalStatus()
            })
        }
        
        if headerViewHeightAnchor.constant <= headerHuggedHeight {
            headerViewHeightAnchor.constant = headerHuggedHeight
            UIView.animateCurveEaseOut(withDuration: 0.2, animations: {
                self.changeStatus()
            })
        }
        
        if stickyHeaderViewHeightAnchor.constant >= headerBGStretchedHeight {
            stickyHeaderViewHeightAnchor.constant = headerBGStretchedHeight
        }
        
        if stickyHeaderViewHeightAnchor.constant <= headerHuggedHeight {
            stickyHeaderViewHeightAnchor.constant = headerHuggedHeight
        }
        
        if headerViewHeightAnchor.constant > headerHuggedHeight &&
            headerViewHeightAnchor.constant < headerStretchedHeight {
            let offsetProgress = (newHeight - headerHuggedHeight) /
                (headerStretchedHeight - headerHuggedHeight)
            self.projectTitleLabel.alpha = offsetProgress
            self.contentTitleLabel.alpha = offsetProgress
            self.listTitleLabel.alpha = 1.0 - offsetProgress
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        scrollDidEnd(offsetY: offsetY)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        scrollDidEnd(offsetY: offsetY)
    }
    
    func scrollDidEnd(offsetY: CGFloat) {
        let currentHeaderViewHeight = headerViewHeightAnchor.constant

        guard currentHeaderViewHeight != huggedHeight ||
            currentHeaderViewHeight != stretchedHeight
        else {
            return
        }
        
        let newHeight = headerViewHeightAnchor.constant - offsetY
        let offsetProgress = (newHeight - huggedHeight) /
            (stretchedHeight - huggedHeight)
        
        if offsetProgress < 0.5 {
            headerViewHeightAnchor.constant = huggedHeight
            stickyHeaderViewHeightAnchor.constant = huggedHeight
            UIView.animateCurveEaseOut(withDuration: 0.5, animations: {
                self.changeStatus()
                self.view.layoutIfNeeded()
            })
        } else {
            headerViewHeightAnchor.constant = stretchedHeight
            stickyHeaderViewHeightAnchor.constant = bgHeight
            UIView.animateCurveEaseOut(withDuration: 0.5, animations: {
                self.normalStatus()
                self.view.layoutIfNeeded()
            })
        }
    }

}


// MARK: - configuration
extension ProjectContentViewController {
    
    func configureCardTableView() {
        
        // collectionview cell 등록
        let tableViewNib = UINib(nibName: "ProjectCardCell", bundle: nil)
        self.cardTableView.register(tableViewNib, forCellReuseIdentifier: "ProjectCardCell")
        
        self.cardTableView.rowHeight = UITableView.automaticDimension
        self.cardTableView.estimatedRowHeight = 100
        
        self.cardTableView.delegate = self
        self.cardTableView.dataSource = self
        
        self.cardTableView.layer.shadowColor = UIColor.black.cgColor // any value you want
        self.cardTableView.layer.shadowOpacity = 0.1 // any value you want
        self.cardTableView.layer.shadowRadius = 5.0 // any value you want
        self.cardTableView.layer.shadowOffset = .init(width: 1, height: 1)
    }
    
    func configureLabel() {
        
        self.contentTitleLabel.font = UIFont(name: "NanumGothicOTFBold", size: 18)
        self.contentTitleLabel.textColor = .white
        
        self.projectTitleLabel.font = UIFont(name: "NanumGothicOTFExtraBold", size: 28)
        self.projectTitleLabel.textColor = .white
        self.projectTitleLabel.text = projectTitle
        
        self.listTitleLabel.font = UIFont(name: "NanumGothicOTFBold", size: 18)
        self.listTitleLabel.textColor = .white
    }
    
    // 스크롤뷰가 내려가지 않았을 때의 뷰
    func normalStatus() {
        self.listTitleLabel.alpha = 0
        self.projectTitleLabel.alpha = 1
        self.contentTitleLabel.alpha = 1
        self.titleStackView.isHidden = false
    }
    
    // 스크롤뷰가 내려가면 보이는 뷰
    func changeStatus() {
        self.listTitleLabel.alpha = 1
        self.projectTitleLabel.alpha = 0
        self.contentTitleLabel.alpha = 0
        self.titleStackView.isHidden = true
    }
    
    func hiddenStatus() {
        self.listTitleLabel.isHidden = listTitleLabel.alpha == 0 ? true : false
        self.projectTitleLabel.isHidden = projectTitleLabel.alpha == 0 ? true: false
        self.contentTitleLabel.isHidden = contentTitleLabel.alpha == 0 ? true: false
    }

}
