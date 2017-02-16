//
//  HashTag.swift
//  Twitter
//
//  Created by Xie kesong on 2/16/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

class HashTag{
    var tagDict: [String: Any]?
    
    
    var indices: Indices?{
        if let (first, second) = self.tagDict?["indices"] as? (Int, Int){
            return Indices(from: first, to: second)
        }
        return nil
    }
    
    var text: String!{
        return self.tagDict?["text"] as! String
    }
    
    init(tagDict: [String: Any]?) {
        self.tagDict = tagDict
    }
    
}
