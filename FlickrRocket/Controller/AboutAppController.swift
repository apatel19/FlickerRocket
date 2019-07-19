//
//  AboutAppController.swift
//  FlickrRocket
//
//  Created by Apurva Patel on 4/27/18.
//  Copyright © 2018 Apurva Patel. All rights reserved.
//

import UIKit

class AboutAppController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTextView()
    }
    
    @IBAction func okButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToViewController", sender: nil)
    }
    
    var content = "This app uses Flickr API to get images from webstie and username of owner. I also used NSCache to store downloaded images. App display images using CollectionView. After tapping on a collection view cell it will open the image into another screen and will have username under the image. For app icon of this app I used Gravity Designer Tool. \n\n\n Creator: Apurva Patel \n Email: patelapurva19@gmail.com"
    
    func loadTextView () {
        textView.text = content
    }
    
}
