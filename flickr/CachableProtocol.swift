//
//  CachableProtocol.swift
//  flickr
//
//  Created by Andrius on 13/04/2016.
//  Copyright © 2016 Andrius Steponavicius. All rights reserved.
//

import Foundation
import UIKit

class Cache: NSCache {
    static let defaultCache = NSCache()
}

protocol Cachable {
    
}
extension Cachable {
    
    var imageCachingKey:String{
        return NSTemporaryDirectory()
    }
    
    /**
     Cache and retrieve data to cache
     
     - parameter urlString: url string used to construct URL and cache key
     - parameter response:  data closure returned from disk/remote
     */
    subscript (urlString:String, response:(NSData)->())->Void{
        let cacheKey = cacheKeyForString(urlString)
        Client.backgroundThread({
            if let data =  NSData(contentsOfFile: cacheKey){
                Client.mainThread({
                    response(data)
                })
                return
            }
            if let url = NSURL(string: urlString), let data = NSData(contentsOfURL: url) {
                Client.mainThread({
                    response(data)
                })
                data.writeToFile(cacheKey, atomically: true)
            }
        })

    }
    private func cacheKeyForString(string:String)->String{
        return imageCachingKey + string.stringByReplacingOccurrencesOfString("/", withString: "")
    }
    
    /**
     If image is requested
     
     - parameter urlString: urlString to construct NSURL for image
     
     - parameter response:  Image response (image:UIImage)
     */
    subscript (urlString:String, response:(UIImage?)->()?)->Void{
        self.fetchImage(urlString, response: response)
    }
    private func fetchImage(urlString:String, response:(UIImage?)->()?)->Void {
        let cacheKey = cacheKeyForString(urlString)
        
        /// If image exist return and exit
        if let cachedImage = Cache.defaultCache.objectForKey(cacheKey) as? UIImage {
            response(cachedImage)
            return
        }
        let dataResponse:(NSData)->() = { (data) -> Void in
            guard let image = UIImage(data: data) else {
                return
            }
            Cache.defaultCache.setObject(image, forKey: cacheKey)
            
            self.fetchImage(urlString, response: response)
        }
        self[urlString, dataResponse]
    }
}