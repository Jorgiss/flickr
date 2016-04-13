//
//  ImageTableViewCell.swift
//  flickr
//
//  Created by Andrius on 13/04/2016.
//  Copyright © 2016 Andrius Steponavicius. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    
    var imageMetadata:ImageMetadata?{
        didSet{
            textLabel?.text = imageMetadata?.title
            imageView?.image = nil
            imageMetadata?.fetchImage({[weak self] (image) in
                self?.imageView?.image = image
                self?.layoutSubviews()
            })
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.contentMode = .ScaleAspectFill
        imageView?.clipsToBounds = true
        imageView?.frame = CGRectMake(0, 0, frame.width, frame.height-55)
        textLabel?.frame = CGRectMake(20, frame.height-55, frame.width-40, 55)
        textLabel?.numberOfLines = 2
    }
    
}
