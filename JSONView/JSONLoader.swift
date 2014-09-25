//
//  JSONLoader.swift
//  wusi-ios
//
//  Created by James Tang on 12/9/14.
//  Copyright (c) 2014 Wusi. All rights reserved.
//

import UIKit

class JSONLoader {

    var json : AnyObject?

    init(name: String) {
        let path = NSBundle(forClass: self.dynamicType).pathForResource(name, ofType: "json")
        let url = NSURL(fileURLWithPath: path!)
        let data = NSData(contentsOfURL: url)
        var error : NSError?
        let obj: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error)
        self.json = obj as [String:AnyObject]?
    }
}
