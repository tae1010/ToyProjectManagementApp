//
//  SharedData.swift
//  ToyProjectManagementApp
//
//  Created by 김정태 on 2022/11/18.
//

import Foundation
import UIKit

/// 마이페이지에 활동내역  + 애플이메일을 저장하기 위한 class
// apple login은 보안때문에 email값을 null 로 반환하기 때문에 로그인할때 주는 token을 string으로 변환해서 저장시켜야함
class SharedData {
    
    static var totalProjectCount = 0
    static var inProgressProjectCount = 0
    static var completeProjectCount = 0
    
    init(totalProjectCount: Int, inProgressProjectCount: Int, completeProjectCount: Int) {
        SharedData.totalProjectCount = totalProjectCount
        SharedData.inProgressProjectCount = inProgressProjectCount
        SharedData.completeProjectCount = completeProjectCount
        print("init성공")
    }

}
