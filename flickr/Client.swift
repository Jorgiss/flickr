//
//  Client.swift
//  flickr
//
//  Created by Andrius on 13/04/2016.
//  Copyright © 2016 Andrius Steponavicius. All rights reserved.
//

import UIKit

class Client: NSObject {

    class func backgroundThread(closure:()->()) {
        dispatch_async(dispatch_get_global_queue( QOS_CLASS_UTILITY, 0), {
            closure()
        })
    }
    class func mainThread(closure:()->()) {
        dispatch_async(dispatch_get_main_queue()) {
            closure()
        }
    }
}
