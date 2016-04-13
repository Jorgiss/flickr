//
//  ImageMetadata.swift
//  flickr
//
//  Created by Andrius on 13/04/2016.
//  Copyright © 2016 Andrius Steponavicius. All rights reserved.
//

import UIKit

class ImageMetadata: NSObject {
    init(dictionary:Dictionary<String, AnyObject>) {
        farm = dictionary["key"] as? String
        server = dictionary["server"] as? String
        id = dictionary["id"] as? String
        secret = dictionary["secret"] as? String
    }
    var farm:String?
    var server:String?
    var secret:String?
    var id:String?
    
}
