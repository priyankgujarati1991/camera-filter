//
//  VideoDataModelList.swift
//  CameraFilter
//
//  Created by Tosc189 on 24/08/18.
//  Copyright © 2018 Tosc189. All rights reserved.
//

import UIKit
import SQLite3
class VideoDataModelList: NSObject {
    
    var desc:String!
    var sourceURL:String!
    var subtitle: String!
    var thumb: String!
    var title : String!
    var isplaying:Bool

    override init() {
        desc = ""
        sourceURL = ""
        subtitle = ""
        thumb = ""
        title = ""
        isplaying = false
    }
    
    let dbManager = AppDelegate.shared.dbManager
    
    func getRecords() -> [VideoDataModelList]{
        var statement: OpaquePointer?
        
        let query = "select desc, sourceURL,subtitle,thumb,title from videoData"
        
        var arrVideoDataModelList = [VideoDataModelList]()
        
        if sqlite3_prepare_v2(dbManager.db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let videoDataModelList = VideoDataModelList()
                
                if let cString = sqlite3_column_text(statement, 0) {
                    videoDataModelList.title = String(cString: cString)
                } else {
                    videoDataModelList.title = ""
                }
                if let cString = sqlite3_column_text(statement, 1) {
                    videoDataModelList.subtitle = String(cString: cString)
                } else {
                    videoDataModelList.subtitle = ""
                }
                if let cString = sqlite3_column_text(statement, 2) {
                    videoDataModelList.thumb = String(cString: cString)
                } else {
                    videoDataModelList.thumb = ""
                }
                if let cString = sqlite3_column_text(statement, 3) {
                    videoDataModelList.sourceURL = String(cString: cString)
                } else {
                    videoDataModelList.sourceURL = ""
                }
                if let cString = sqlite3_column_text(statement, 4) {
                    videoDataModelList.desc = String(cString: cString)
                } else {
                    videoDataModelList.desc = ""
                }
                
                arrVideoDataModelList.append(videoDataModelList)
                }
            
            }
    
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(dbManager.db)!)
            print("Error finalizing prepared statement: \(errmsg)")
        }
        
        statement = nil
        return arrVideoDataModelList
    }
    
//    func getCarDetaiByCarId(carId:String) -> CarList{
//        var statement: OpaquePointer?
//        let carList = CarList()
//
//        let query = "select carId, carName,company,registrationNo,purchaseDate,rsa,engineNo, vinNo,color,carImagePath from CarInfo where carId = \(carId)"
//
//
//        if sqlite3_prepare_v2(dbManager.db, query, -1, &statement, nil) == SQLITE_OK {
//            while sqlite3_step(statement) == SQLITE_ROW {
//                if let cString = sqlite3_column_text(statement, 0) {
//                    carList.carId = String(cString: cString)
//                } else {
//                    carList.carId = ""
//                }
//
//                if let cString = sqlite3_column_text(statement, 1) {
//                    carList.carName = String(cString: cString)
//                } else {
//                    carList.carName = ""
//                }
//
//                if let cString = sqlite3_column_text(statement, 2) {
//                    carList.carCompany = String(cString: cString)
//                } else {
//                    carList.carCompany = ""
//                }
//
//                if let cString = sqlite3_column_text(statement, 3) {
//                    carList.registrationNo = String(cString: cString)
//                } else {
//                    carList.registrationNo = ""
//                }
//
//                if let cString = sqlite3_column_text(statement, 4) {
//                    carList.purchaseDate = String(cString: cString)
//                } else {
//                    carList.purchaseDate = ""
//                }
//
//                if let cString = sqlite3_column_text(statement, 5) {
//                    carList.rsaDate = String(cString: cString)
//                } else {
//                    carList.rsaDate = ""
//                }
//                if let cString = sqlite3_column_text(statement, 6) {
//                    carList.enginNo = String(cString: cString)
//                } else {
//                    carList.enginNo = ""
//                }
//                if let cString = sqlite3_column_text(statement, 7) {
//                    carList.vinNo = String(cString: cString)
//                } else {
//                    carList.vinNo = ""
//                }
//                if let cString = sqlite3_column_text(statement, 8) {
//                    carList.color = String(cString: cString)
//                } else {
//                    carList.color = ""
//                }
//                if let cString = sqlite3_column_text(statement, 9) {
//                    carList.carImagePath = String(cString: cString)
//                } else {
//                    carList.carImagePath = ""
//                }
//
//                //arrCarList.append(carList)
//            }
//        }
//
//        if sqlite3_finalize(statement) != SQLITE_OK {
//            let errmsg = String(cString: sqlite3_errmsg(dbManager.db)!)
//            print("Error finalizing prepared statement: \(errmsg)")
//        }
//
//        statement = nil
//        return carList
//    }
//    func updateImagePathForNewAppversion(id:String,imagePath:String){
//
//        let updateStatementString = "UPDATE CarInfo SET carImagePath = '\(imagePath)' where carId = \(id)"
//
//        let insertSt = updateStatementString.cString(using: String.Encoding.utf8)
//
//        if sqlite3_exec(dbManager.db, insertSt, nil, nil, nil) != SQLITE_OK {
//            let errmsg = String(cString: sqlite3_errmsg(dbManager.db)!)
//            print("Error inserting data into Database: \(errmsg)")
//        }else{
//            print("Update into Database SuccessFully")
//        }
//    }
}
