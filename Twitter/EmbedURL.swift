//
//  EmbedURL.swift
//  Twitter
//
//  Created by Xie kesong on 2/15/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//


class EmbedURL{
    var urlDict: [String: Any]?
    
    
    var indices: Indices?{
        if let (first, second) = self.urlDict?["indices"] as? (Int, Int){
            return Indices(from: first, to: second)
        }
        return nil
    }
    
    var urlString: String!{
        return self.urlDict?["url"] as! String
    }
    
    init(urlDict: [String: Any]?) {
        self.urlDict = urlDict
    }
    
}
