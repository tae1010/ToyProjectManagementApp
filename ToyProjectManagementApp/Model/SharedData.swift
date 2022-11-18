//
//  SharedData.swift
//  ToyProjectManagementApp
//
//  Created by 김정태 on 2022/11/18.
//

import Foundation
import UIKit


/// 마이페이지에 활동내역 저장하기 위한 class
class SharedData {
    
    static var totalProjectCount = 0
    static var inProgressProjectCount = 0
    static var completeProjectCount = 0
    
//    init() {
//        self.totalProjectCount = 0
//        self.inProgressProjectCount = 0
//        self.completeProjectCount = 0
//    }
    
    init(totalProjectCount: Int, inProgressProjectCount: Int, completeProjectCount: Int) {
        SharedData.totalProjectCount = totalProjectCount
        SharedData.inProgressProjectCount = inProgressProjectCount
        SharedData.completeProjectCount = completeProjectCount
        print("init성공")
    }
    
    static func printCount() {
        
        print(totalProjectCount, inProgressProjectCount, completeProjectCount, "printCount실행")
    }
    
}
