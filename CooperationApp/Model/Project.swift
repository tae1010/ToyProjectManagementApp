//
//  Project.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/04/13.
//

import Foundation

struct Project {
    var id: String //uuidstring
    var user: [String] // 프로젝트 사용자
    var projectTitle: String // 프로젝트 제목
    var important: Bool // 프로젝트 중요도 표시
    var currentTime: Int // 프로젝트 생성일/수정일
}
