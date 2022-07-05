//
//  ProjectDetailcontent.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/06/29.
//

import Foundation

struct ProjectDetailcontent {
    var cardName: String
    var color: String
    var startTime: String
    var endTime: String
    
    init(_ cardName: String) {
        self.cardName = cardName
        self.color = "blue"
        self.startTime = "20220701"
        self.endTime = "20220702"
    }
    
    init(_ cardName: String, _ color: String, _ startTime: String, _ endTime: String) {
        self.cardName = cardName
        self.color = color
        self.startTime = startTime
        self.endTime = endTime
    }
    
}
