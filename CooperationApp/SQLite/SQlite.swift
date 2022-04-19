//
//  SQlite.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/04/19.
//

import Foundation
import SQLite3

class SQlite {
    
    static let shared = SQlite()
    var db: OpaquePointer?
    let databaseName = "cooperationDB.sqlite"
    
    
    init() {
        self.db = createDB()
    }
    
    deinit {
        sqlite3_close(db)
    }
    
    private func createDB() -> OpaquePointer? {

        do {
            let dbPath: String = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false).appendingPathComponent(databaseName).path
            
            if sqlite3_open(dbPath, &db) == SQLITE_OK {
                print("Successfully created DB. Path: \(dbPath)")
                return db
            }
        } catch {
            print("Error while creating Database -\(error.localizedDescription)")
        }
        return nil
    }
    
    // 테이블 생성
    func createTable(){
        // 아래 query의 뜻.
        // mytable이라는 table을 생성한다. 필드는
        // id(int, auto-increment primary key)
        // my_name(String not null)
        // my_age(Int)
        // 로 구성한다.
        // auto-increment 속성은 INTEGER에만 가능하다.
        let query = """
           CREATE TABLE IF NOT EXISTS myTable(
           id INTEGER PRIMARY KEY AUTOINCREMENT,
           user TEXT NOT NULL,
           my_age INT
           );
           """
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("\nCreating table has been succesfully done. db: \(String(describing: self.db))")
                
            }
            else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("\nsqlte3_step failure while creating table: \(errorMessage)")
            }
        }
        else {
            let errorMessage = String(cString: sqlite3_errmsg(self.db))
            print("\nsqlite3_prepare failure while creating table: \(errorMessage)")
        }
        
        sqlite3_finalize(statement) // 메모리에서 sqlite3 할당 해제.
    }
    
    // 데이터 삽입
    func insert(_ tableName: String, _ title : String, _ subline : String, _ date : String ){
        var stmt : OpaquePointer?
        
        let INSERT_QUERY_TEXT : String = "INSERT INTO \(tableName) (title, subline, date) Values (?,?,?)"
        
        if sqlite3_prepare(db, INSERT_QUERY_TEXT, -1, &stmt, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert:v1 \(errMsg)")
            return
        }
        
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        
        if sqlite3_bind_text(stmt, 1, title, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("failture binding name: \(errMsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 2, subline, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("failture binding name: \(errMsg)")
            return
        }
        
        
        if sqlite3_bind_text(stmt, 3, date, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("failture binding name: \(errMsg)")
            return
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("insert fail :: \(errMsg)")
            return
        }
    }
    
    //데이터 검색
    func selectValue(_ tableName: String){
        
        let SELECT_QUERY = "SELECT * FROM \(tableName)"
        var stmt:OpaquePointer?
        
        
        if sqlite3_prepare(db, SELECT_QUERY, -1, &stmt, nil) != SQLITE_OK{
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: v1\(errMsg)")
            return
        }
        
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let title = String(cString: sqlite3_column_text(stmt, 1))
            let subline = String(cString: sqlite3_column_text(stmt, 2))
            let date = String(cString: sqlite3_column_text(stmt, 3))
            
            print("read value id : \(id) title : \(title) subline : \(subline) date : \(date)")
        }
    }
    
    //데이터 업데이트
    func update(_ tableName: String, _ index:String, _ title : String,_ subline : String, _ date : String){
        let UPDATE_QUERY = "UPDATE \(tableName) Set title = '\(title)', subline = '\(subline)', date= '\(date)' WHERE id == \(index)"
        var stmt:OpaquePointer?
        print(UPDATE_QUERY)
        if sqlite3_prepare(db, UPDATE_QUERY, -1, &stmt, nil) != SQLITE_OK{
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing update: v1\(errMsg)")
            return
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("update fail :: \(errMsg)")
            return
        }
        
        sqlite3_finalize(stmt)
        print("update success")
    }
    
    
    //데이터 삭제
    func delete(_ tableName: String,_ index:String){
        let DELETE_QUERY = "DELETE FROM \(tableName) WHERE id = \(index)"
        var stmt:OpaquePointer?
        
        print(DELETE_QUERY)
        if sqlite3_prepare_v2(db, DELETE_QUERY, -1, &stmt, nil) != SQLITE_OK{
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing delete: v1\(errMsg)")
            return
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("delete fail :: \(errMsg)")
            return
        }
        sqlite3_finalize(stmt)
        
    }
}
