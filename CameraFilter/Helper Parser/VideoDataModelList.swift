//
//  VideoDataModelList.swift
//  CameraFilter
//
//  Created by Tosc189 on 24/08/18.
//  Copyright © 2018 Tosc189. All rights reserved.
//

import UIKit

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
}
