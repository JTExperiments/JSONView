//
//  FeatureTableViewCell.swift
//  JSONView
//
//  Created by James Tang on 25/9/14.
//  Copyright (c) 2014 James Tang. All rights reserved.
//

import UIKit

class FeatureTableViewCell: UITableViewCell {

    @IBInspectable var value : String? {
        didSet {
            self.detailTextLabel?.text = value
        }
    }

    override func setValue(value: AnyObject!, forKey key: String!) {
        if key == "image" {
            return
        }
        super.setValue(value, forKey: key)
    }

}
