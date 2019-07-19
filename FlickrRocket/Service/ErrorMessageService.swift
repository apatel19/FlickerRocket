//
//  MessageLabelService.swift
//  FlickrRocket
//
//  Created by Apurva Patel on 4/27/18.
//  Copyright © 2018 Apurva Patel. All rights reserved.
//

import Foundation

class ErrorMessageService {
    
    func imageRelatedError (with reason : String) {
        print ("Error downloading image : \(reason)")
    }
    
    func jsonParsingError (with reason : String) -> String{
        return "Error occured while acsessing: \(reason)"
    }
    
    func urlConstructionError (with reason : String) -> String {
        return "Error in url : \(reason)"
    }
    
}
