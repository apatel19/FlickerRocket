//
//  CollectionViewCell.swift
//  FlickrRocket
//
//  Created by Apurva Patel on 4/26/18.
//  Copyright © 2018 Apurva Patel. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var flickrImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var downloadingIndicator: UIActivityIndicatorView!
    
}
