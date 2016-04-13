//
//  ImageMetadata.swift
//  flickr
//
//  Created by Andrius on 13/04/2016.
//  Copyright © 2016 Andrius Steponavicius. All rights reserved.
//

import UIKit

class ImageMetadata: NSObject, Cachable {
    init(dictionary:Dictionary<String, AnyObject>) {
        farm = dictionary["farm"] as? Int
        server = dictionary["server"] as? String
        id = dictionary["id"] as? String
        secret = dictionary["secret"] as? String
        title = dictionary["title"] as? String
    }
    var title:String?
    var farm:Int?
    var server:String?
    var secret:String?
    var id:String?
    
    var imageURL:String {
        guard let farm = farm, let server = server, let id = id, let secret = secret else{
            print("Invalid metadata")
            
            return ""
        }
        return "http://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret).jpg"
    }
    
    func fetchImage(completion:(UIImage?)->()) {
        return self[imageURL, completion]
    }
}
