//
//  ColorView.swift
//  JSONView
//
//  Created by James Tang on 25/9/14.
//  Copyright (c) 2014 James Tang. All rights reserved.
//

import UIKit

@IBDesignable
class ColorView: JSONView {

    var label : UILabel!

    @IBInspectable var text : String? {
        didSet {
            label.text = text
        }
    }

    required override init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }

    func initView() {
        label = UILabel(frame: self.bounds)
        label.autoresizingMask = .FlexibleHeight | .FlexibleWidth
        label.setTranslatesAutoresizingMaskIntoConstraints(true)
        self.addSubview(label)
    }
}
