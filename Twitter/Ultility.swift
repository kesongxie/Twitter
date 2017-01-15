//
//  Ultility.swift
//  Twitter
//
//  Created by Xie kesong on 1/15/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import Foundation

class Ultility: NSObject {
    class func agoString(from UTCDateTimeString: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        if let date = dateFormatter.date(from: UTCDateTimeString){
            return Ultility.ago(fromDate: date)
        }else{
            return ""
        }
    }
    
    class func ago(fromDate date: Date) -> String{
        let ellapseTimeSeconds = Int(-date.timeIntervalSinceNow)
        var output: String = ""
        if ellapseTimeSeconds < 15{
            output = "Just Now"
        }else if ellapseTimeSeconds < 60{
            output = "\(ellapseTimeSeconds)s"
        }else if ellapseTimeSeconds < 60 * 60{
            output = "\(ellapseTimeSeconds / 60)m"
        }else if ellapseTimeSeconds < 60  * 60 * 24{
            output = "\(ellapseTimeSeconds / 3600)h"
        }else if ellapseTimeSeconds < 60 * 60 * 24 * 7{
            output = "\(ellapseTimeSeconds / 3600 * 24)d"
        }else{
            output = "\(ellapseTimeSeconds / 3600 * 24 * 7)w"
        }
        return output;
    }
    
}
