//
//  FirebaseDB.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/04/19.
//

import Foundation
import FirebaseDatabase

class FirebaseDB {
    
    init() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
    }
    
}
