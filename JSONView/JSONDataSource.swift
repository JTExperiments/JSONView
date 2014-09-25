//
//  JSONDataSource.swift
//  wusi-ios
//
//  Created by James Tang on 12/9/14.
//  Copyright (c) 2014 Wusi. All rights reserved.
//

import Foundation

class JSONDataSource : NSObject {

    var json : AnyObject?
    // MARK: Init
    
    init(name: String) {
        self.json = JSONLoader(name: name).json
    }

    init(json: AnyObject?) {
        self.json = json
    }

}
