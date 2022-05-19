//
//  ProjectContent.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/05/14.
//

import Foundation

struct ProjectContent {
    var id: String // Project 구조체에 있는 id 저장
    var countIndex: Int // 몇번째 배열인지 저장하는함수
    var content: Dictionary<String, [String]> // title과 content들을 저장할 dictionary
}
