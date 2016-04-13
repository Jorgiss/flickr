//
//  RootViewController.swift
//  flickr
//
//  Created by Andrius on 13/04/2016.
//  Copyright © 2016 Andrius Steponavicius. All rights reserved.
//

import UIKit

class RootViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(ImageTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(ImageTableViewCell))
        
        APIRequest().findImagesRequest { (objects) in
            self.images.appendContentsOf(objects)
            self.tableView.reloadData()
        }
    }
    
    var images:[ImageMetadata] = []
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(Int(tableView.frame.width/16*9))+55
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(ImageTableViewCell)) as! ImageTableViewCell
        cell.imageMetadata = images[indexPath.row]
        return cell
    }
}
