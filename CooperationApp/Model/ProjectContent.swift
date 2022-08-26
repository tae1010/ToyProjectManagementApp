//
//  ProjectContent.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/05/14.
//

import Foundation

// project 내용
struct ProjectContent: Codable {
    var listTitle: String
    var index: Int
    var detailContent: [ProjectDetailContent] // cardName, color, startTime, endTime
}

// projectList 내용 (card 내용)
struct ProjectDetailContent: Codable {
    var cardName: String?
    var color: String?
    var startTime: String?
    var endTime: String?
}



