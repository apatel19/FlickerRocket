//
//  URLService.swift
//  FlickrRocket
//
//  Created by Apurva Patel on 4/27/18.
//  Copyright © 2018 Apurva Patel. All rights reserved.
//

import Foundation

class URLService {

    func getFlickerURL () -> String {
        return "https://api.flickr.com/services/rest/?format=json&sort=random&method=flickr.photos.search&tags=rocket&tag_mode=all&api_key=0e2b6aaf8a6901c264acb91f151a3350&nojsoncallback=1"
    }
    
    func createImageURL (with photo: [String :Any]) -> String {
        return "https://farm" + "\(photo["farm"]!)" + "." + "static.flickr.com/" + "\(photo["server"]!)" + "/" + "\(photo["id"]!)" + "_" + "\(photo["secret"]!)" + ".jpg"
    }
    
    func createUserNameURL (with id:String) -> String{
        return  "https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=0e2b6aaf8a6901c264acb91f151a3350&photo_id=" + "\(id)" + "&format=json&nojsoncallback=1"
    }
}
