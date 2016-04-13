//
//  APIRequest.swift
//  flickr
//
//  Created by Andrius on 13/04/2016.
//  Copyright © 2016 Andrius Steponavicius. All rights reserved.
//

import UIKit
let baseURL = "https://api.flickr.com/services/rest/"

///?method=flickr.photos.search&api_key=907dea022b0dfc2ec993df236bc0fe6c&text=wall&format=json&nojsoncallback=1&auth_token=72157664827692513-80f0a0ad1bbabe1c&api_sig=ba52af727b909647aeae3e52d86be19d

extension APIRequest {
    func findImagesRequest(completion:([ImageMetadata])->()) -> Void {
        method = "flickr.photos.search"
        params = "&text=wall"
        performRequest()
    }
}

class APIRequest: NSObject {
    
    var method:String = ""
    var params:String = ""
    
    private let flickrKey = "32123438bf1e760b6abb02990e74fbcb"
    
    private var requestURL:NSURL {
        return NSURL(string: baseURL +
            "?method="+"\(method)" +
            "&format=json&nojsoncallback=1" +
            "&api_key=\(flickrKey)" + params)!
    }
    
    private var apiRequest:NSMutableURLRequest {
        let request = NSMutableURLRequest(URL:requestURL, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 5)
        return request
    }

    func performRequest(){
        print(requestURL)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        session.dataTaskWithRequest(apiRequest) { (data, response, error) in
            print(data)
            if let data = data {
                let parsedData = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
                print(parsedData)

            }
        }.resume()
    }
}
