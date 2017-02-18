//
//  UserMention.swift
//  Twitter
//
//  Created by Xie kesong on 2/16/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import Foundation

class UserMention{
    var mentionDict: [String: Any]?
    
    var id: Int64?{
        return self.mentionDict?["id"] as? Int64
    }

    var screen_name: String!{
        return self.mentionDict?["screen_name"] as! String
    }
    
    init(mentionDict: [String: Any]?) {
        self.mentionDict = mentionDict
    }
}
