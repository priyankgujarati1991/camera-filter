//
//  VideoParser.swift
//  CameraFilter
//
//  Created by Tosc189 on 24/08/18.
//  Copyright © 2018 Tosc189. All rights reserved.
//

import UIKit

protocol VideoParserDelegate {
    func videoParserSuccess(_ arrVideoData:[VideoDataModelList])
    func videoParserFailure(_ message:String)
}

class VideoParser: NSObject {

    var delegate :VideoParserDelegate!
    
    var videoDataModel = VideoDataModelList()
}


extension VideoParser {
    
    func getData(){
        
        let session = URLSession.shared
        
        let path = Bundle.main.path(forResource: "VideoList", ofType: "json")
        
        let url = URL(fileURLWithPath: path!)
        
        do{
             var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            let dataTask = session.dataTask(with: request, completionHandler: {
                data , response , error in
                
                if error == nil && data != nil{
//                    if let httpResponse = response as? HTTPURLResponse{
//                        if httpResponse.statusCode == 200{
                    
                            self.parseResponseData(data!)
//                        }else{
//                            DispatchQueue.main.async {
//                                self.delegate.videoParserFailure("")
//                            }
//                        }
//                    }
                }else{
                    DispatchQueue.main.async {
                        self.delegate.videoParserFailure(error!.localizedDescription)
                    }
                }
            })
            dataTask.resume()
        }
    }
    
    func parseResponseData(_ data:Data) {
        do{
            let responseData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:[[String:Any]]]
            let arrVideos = responseData["videos"]!
            
            if arrVideos.count > 0 {
                
                var arrVideoData = [VideoDataModelList]()
                
                for dict in arrVideos{
                    
                    let dataModel = VideoDataModelList()
                    
                    if let strdescription = dict["description"] as? String {
                        dataModel.desc = "\(strdescription)"
                    }else{
                        dataModel.desc = ""
                    }
                    
                    if let strthumb = dict["thumb"] as? String{
                        dataModel.thumb = strthumb
                    }else{
                        dataModel.thumb = ""
                    }
                    
                    if let arrSources = dict["sources"] as? [String] , arrSources.count > 0{
                        dataModel.sourceURL = arrSources[0]
                    }else{
                        dataModel.sourceURL = ""
                    }
                    
                    if let strTitle = dict["title"] as? String{
                        dataModel.title = strTitle
                    }else{
                        dataModel.title = ""
                    }
                    
                    if let strSubTitle = dict["subtitle"] as? String{
                        dataModel.subtitle = strSubTitle
                    }else{
                        dataModel.subtitle = ""
                    }
                    
                    arrVideoData.append(dataModel)
                }
                
                DispatchQueue.main.async {
                    self.delegate.videoParserSuccess(arrVideoData)
                }
            }
    
        }catch{
            DispatchQueue.main.async {
                self.delegate.videoParserFailure("")
            }
        }
    }
}
