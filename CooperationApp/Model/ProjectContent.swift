//
//  ProjectContent.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/05/14.
//

import Foundation

struct ProjectContent: Codable {
    var listTitle: String
    var index: Int
    var detailContent: [ProjectDetailContent] // cardName, color, startTime, endTime
//
//    init() {
//        self.listTitle = ""
//        self.index = 0
//        self.detailContent = []
//    }
//
//    init(listTitle: String, index: Int, detailContent : [ProjectDetailContent]) {
//        self.listTitle = listTitle
//        self.index = index
//        self.detailContent = detailContent
//    }
}

struct ProjectDetailContent {
    var cardName: String
    var color: String
    var startTime: String
    var endTime: String
//    
//    init(){
//        self.cardName = ""
//        self.color = ""
//        self.startTime = ""
//        self.endTime = ""
//    }
//
//    init(cardName: String, color: String, startTime: String, endTime: String) {
//        self.cardName = cardName
//        self.color = color
//        self.startTime = startTime
//        self.endTime = endTime
//    }
}
