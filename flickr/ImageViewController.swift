//
//  ImageViewController.swift
//  flickr
//
//  Created by Andrius on 13/04/2016.
//  Copyright © 2016 Andrius Steponavicius. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(scrollView)
        scrollView.frame = view.bounds
        scrollView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        view.backgroundColor = .whiteColor()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action:#selector(doneButtonPressed))
        
        
        detailView.frame = CGRectMake(0, view.frame.height-80, view.frame.width, 80)
        detailView.autoresizingMask = [.FlexibleWidth, .FlexibleTopMargin]
        
        view.addSubview(detailView)
        
        detailView.addSubview(descriptionLabel)
        descriptionLabel.frame = CGRectMake(20, 10, detailView.frame.width-40, 60)
        descriptionLabel.autoresizingMask = [.FlexibleWidth]

        
    }
    
    func doneButtonPressed(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    private lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 2
        scrollView.delegate = self
        scrollView.addSubview(self.imageView)
        return scrollView
    }()
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    var image:ImageMetadata?{
        didSet{
            descriptionLabel.text = image?.title
            image?.fetchImage {[weak self] (image) in
                self?.imageView.image = image
                self?.imageView.sizeToFit()
            }
        }
    }
    
    private lazy var detailView:UIView = {
       let view = UIView()
        view.backgroundColor = .whiteColor()
        return view
    }()
    
    private lazy var descriptionLabel:UILabel = {
       let label = UILabel()
        label.backgroundColor = .whiteColor()
        label.numberOfLines = 0
        label.textAlignment = .Center
        return label
    }()
    
    private lazy var imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.userInteractionEnabled = false
        return imageView
    }()
    
    
}
