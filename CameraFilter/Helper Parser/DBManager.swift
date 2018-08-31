//
//  DBManager.swift
//  CameraFilter
//
//  Created by Tosc189 on 31/08/18.
//  Copyright © 2018 Tosc189. All rights reserved.
//

import UIKit
import SQLite3
class DBManager: NSObject {

    var db:OpaquePointer?
    
    override init() {
        super.init()
        self.createDatabaseAndCopy()
        self.openDatabase()
    }

    func createDatabaseAndCopy (){
        
        let databaseName = "demo.sqlite"
        
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let fileURL = docDir.appending("/\(databaseName)")
        print("Database Path:  \(fileURL)")
        
        let blnDatabase = FileManager.default.fileExists(atPath: fileURL)
        
        if !blnDatabase {
            let defaultPath = Bundle.main.resourcePath!.appending("/\(databaseName)")
            do{
                try FileManager.default.copyItem(atPath: defaultPath, toPath: fileURL)
                print("Database Copied")
            }catch{
                print("Error in database Copy")
            }
        }
    }
    
    func openDatabase(){
        let databaseName = "demo.sqlite"
        
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let fileURL = docDir.appending("/\(databaseName)")
        
        if sqlite3_open(fileURL, &db) != SQLITE_OK {
            print("Error opening database")
        }
        
    }
    
    func createTable(queryString:String){
        
        let createtable = queryString.cString(using: String.Encoding.utf8)
        
        if sqlite3_exec(db, createtable,nil, nil,nil) != SQLITE_OK{
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errMsg)")
        }
    }
    
    func insertRecord(queryString:String){
        
        let insertRecord = queryString.cString(using: String.Encoding.utf8)
        
        if sqlite3_exec(db, insertRecord, nil, nil,nil) != SQLITE_OK{
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("Error inserting data into Database: \(errMsg)")
        }else{
            print("Inserted into Database SuccessFully")
        }
        
    }
}
