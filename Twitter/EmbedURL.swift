//
//  EmbedURL.swift
//  Twitter
//
//  Created by Xie kesong on 2/15/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//


class EmbedURL{
    var urlDict: [String: Any]?
    
    var urlString: String?{
        return self.urlDict?["url"] as? String
    }
    
    var displayUrl: String?{
        return self.urlDict?["display_url"] as? String
    }
    
    
    var expandedUrl: String?{
        return self.urlDict?["expanded_url"] as? String
    }
    
    init(urlDict: [String: Any]?) {
        self.urlDict = urlDict
    }
    
}
