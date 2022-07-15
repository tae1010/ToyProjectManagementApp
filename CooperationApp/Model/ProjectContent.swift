//
//  ProjectContent.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/05/14.
//

import Foundation

struct ProjectContent {
    var listTitle: String
    var index: Int
    var detailContent: [ProjectDetailContent] // cardName, color, startTime, endTime
}

struct ProjectDetailContent {
    var cardName: String
    var color: String
    var startTime: String
    var endTime: String

    init(cardName: String, color: String, startTime: String, endTime: String) {
        self.cardName = cardName
        self.color = color
        self.startTime = startTime
        self.endTime = endTime
    }
}
