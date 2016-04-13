//
//  Client.swift
//  flickr
//
//  Created by Andrius on 13/04/2016.
//  Copyright © 2016 Andrius Steponavicius. All rights reserved.
//

import UIKit
import RealmSwift

class Client: NSObject {

    private var realmInstance:Realm?{
        do {
            return try Realm(configuration: Realm.Configuration(
                path: Client.realmPath,
                inMemoryIdentifier: nil,
                encryptionKey: nil,
                readOnly: false,
                schemaVersion:1,
                migrationBlock: { migration, oldSchemaVersion in
                    print(migration)
                    print(oldSchemaVersion)
                },
                objectTypes: nil))
        }catch _ {
            /// Panic mode initiated, delete realm instance
            try! NSFileManager.defaultManager().removeItemAtPath(Client.realmPath)
            return self.realmInstance
        }
    }
    
    private class var realmPath:String{
        let dirContents = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)
        if let libraryDirectory = dirContents.first {
            return libraryDirectory.stringByAppendingString("/realm.realm")
        }
        return NSTemporaryDirectory().stringByAppendingString("realm.realm")
    }
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
