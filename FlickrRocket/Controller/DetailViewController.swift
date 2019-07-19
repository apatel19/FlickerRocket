//
//  DetailViewController.swift
//  FlickrRocket
//
//  Created by Apurva Patel on 4/27/18.
//  Copyright © 2018 Apurva Patel. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    var userName : String?
    var image : UIImage?
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var imageOwnerUserName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }

    func updateView () {
       imageOwnerUserName.text = userName
        detailImageView.image = image
    }
}
