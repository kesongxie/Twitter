//
//  UserMention.swift
//  Twitter
//
//  Created by Xie kesong on 2/16/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import Foundation

/*
 id = 2455053222;
 "id_str" = 2455053222;
 indices =     (
 42,
 54
 );
 name = "Samantha Stosur";
 "screen_name" = bambamsam30;
 */



class UserMention{
    var mentionDict: [String: Any]?
    
    var id: Int64?{
        return self.mentionDict?["id"] as? Int64
    }

    var indices: Indices?{
        print(self.mentionDict?["indices"])
        if let (first, second) = self.mentionDict?["indices"] as? (Int, Int){
            print("good cast")
            return Indices(from: first, to: second)
        }
        return nil
    }

    var screen_name: String!{
        return self.mentionDict?["screen_name"] as! String
    }
    
    
    
    init(mentionDict: [String: Any]?) {
        self.mentionDict = mentionDict
    }
    
    
    
}
