//
//  FeatureTableViewCell.swift
//  JSONView
//
//  Created by James Tang on 25/9/14.
//  Copyright (c) 2014 James Tang. All rights reserved.
//

import UIKit

class StyleTableViewCell: UITableViewCell {

    var map : [String:String]?

    @IBInspectable var style : String? {
        didSet {
            if let style = style {
                let json = JSONLoader(name: "style").json as NSDictionary
                self.map = json[".\(style)"] as? [String:String]
            } else {
                self.map = nil
            }
        }
    }

    override func setValue(value: AnyObject!, forKeyPath keyPath: String!) {

        let path : String = self.map != nil ? self.map![keyPath] ?? keyPath : keyPath

//        println("setValue:\(value) forKey:\(keyPath)")

        if path == "." {
            return
        }

        super.setValue(value, forKeyPath: path)

    }

    override func respondsToSelector(aSelector: Selector) -> Bool {
        var responds = super.respondsToSelector(aSelector)

        let selector = NSStringFromSelector(aSelector)

        if let sections = self.map?.keys {
            if let index = find(sections, selector) {
                responds = true
            }
        }

        return responds
    }

}
