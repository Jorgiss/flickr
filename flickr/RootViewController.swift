//
//  RootViewController.swift
//  flickr
//
//  Created by Andrius on 13/04/2016.
//  Copyright © 2016 Andrius Steponavicius. All rights reserved.
//

import UIKit

class RootViewController: UITableViewController, ShyNavigationBarViewController, UISearchBarDelegate {
    
    var initialScrollPositionY:CGFloat?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.keyboardDismissMode = .OnDrag
        tableView.registerClass(ImageTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(ImageTableViewCell))
        
        navigationItem.titleView = searchBar
    }
    
    private lazy var searchBar:UISearchBar = {
       let searchBar = UISearchBar()
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var searchButton:UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Search", style: .Done, target: self, action: #selector(searchButtonPressed))
        
        return button
    }()
    
    let pageSize = 20
    
    var pageNumber:Int = 0
    
    func searchButtonPressed(){
        images = []
        searchBar.resignFirstResponder()
        tableView.reloadData()
        pageNumber = 0
        
        guard let searchText = searchBar.text else {
            return
        }
        self.searchText = searchText
        fetchImages()
    }
    
    var searchText:String?
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem = searchButton
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem = nil
    }
    
    func fetchImages(){
        guard let searchText = searchText else {
            return
        }
        APIRequest().findImagesRequest(searchText, page: pageNumber, pageSize: pageSize) { (objects) in
            self.images.appendContentsOf(objects)
            self.tableView.reloadData()
        }
    }
    
    func insertPage(){

        pageNumber += 1
        fetchImages()
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
        if (pageNumber+1)*pageSize < indexPath.row + 5 {
            insertPage()
        }
        cell.imageMetadata = images[indexPath.row]
        return cell
    }
}
