//
//  JSONView.swift
//  wusi-ios
//
//  Created by James Tang on 12/9/14.
//  Copyright (c) 2014 Wusi. All rights reserved.
//

import UIKit


@objc protocol JsonAttributeAssignable {
    func setAttribute(value:AnyObject, forKey key:String)
}

extension UIView {
    func assignDictionary(dict: [String:AnyObject], recursiveLevel: Int) {
        if recursiveLevel != 0 {
            for view in self.subviews {
                let view = view as UIView
                view.assignDictionary(dict, recursiveLevel:recursiveLevel - 1)
            }
        }

        for (key, value) in dict {

            if let s = self as? JsonAttributeAssignable {
                s.setAttribute(value, forKey:key)
            } else if self.respondsToSelector(Selector(key)) {
                println("key: \(key) = \(value)")
                self.setValue(value, forKeyPath:key)
                //                    println("view \(self) setting value '\(value) for '\(key)'")
            } else {
                //                    println("view \(self) not responds to selector '\(key)'")
            }
        }
    }
}

@IBDesignable
class JSONView : UIView {
    @IBInspectable var load : String?
    @IBInspectable var identifier : String?
    @IBInspectable var recursiveLevel : NSNumber? = 1

    func commonInit() {
        if let load = load {
            self.assignDictionary(JSONLoader(name: load).json as [String:AnyObject], recursiveLevel: 1)
        }
    }

    override func awakeFromNib() {
        self.commonInit()
    }

    override func prepareForInterfaceBuilder() {
        self.commonInit()
    }

    override func assignDictionary(dict: [String : AnyObject], recursiveLevel: Int) {
        if let identifier = identifier {
            if let info : AnyObject? = dict[identifier]  {
                if let info = info as? [String : AnyObject] {
                    super.assignDictionary(info, recursiveLevel: self.recursiveLevel ?? recursiveLevel)
                }
            }
        }
        else {
            super.assignDictionary(dict, recursiveLevel: self.recursiveLevel ?? recursiveLevel)
        }
    }
}

class JSONLabel : UILabel {
    @IBInspectable var identifier : String?

    override func setValue(value: AnyObject!, forKey key: String!) {
        if key == identifier {
            super.setValue(value, forKey: "text")
        } else {
            super.setValue(value, forKey: key)
        }
    }
}

protocol JSONSource {
    var json : [String:AnyObject]? {get}
}

protocol JSONDestination : JSONSource {
    var json : [String:AnyObject]? {set get}
}

class JSONViewController: UIViewController, JSONDestination {
    var json : [String:AnyObject]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.assignDictionary(json!, recursiveLevel: 1)
    }
}

@IBDesignable
class JSONTableView : UITableView, UITableViewDataSource {

    var ids : [String]?
    var info : NSMutableDictionary? = NSMutableDictionary()

    override func awakeFromNib() {
        self.dataSource = self
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let identifier = ids?[section] {
            let data = info?[identifier] as NSDictionary
            let ids = data["ids"] as [String]
            return ids.count
        }
        return 0
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let count = ids?.count ?? 0
        println("count: \(count)")
        return count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = ids?[indexPath.section] ?? "cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell

        let data = info?[cellIdentifier] as NSDictionary
        let rowIdentifier = data["ids"] as [String]
        let dataId = rowIdentifier[indexPath.row]
        let dict = data[dataId] as NSDictionary

        cell.assignDictionary(dict as [String: AnyObject], recursiveLevel: 1)

        return cell
    }

    override func respondsToSelector(aSelector: Selector) -> Bool {
        var responds = super.respondsToSelector(aSelector)

        let selector = NSStringFromSelector(aSelector)

        if let sections = ids {
            if let index = find(sections, selector) {
                responds = true
            }
        }
        println("respondsTo \(aSelector) = \(responds)")

        return responds
    }

    override func setValue(value: AnyObject!, forUndefinedKey key: String!) {
        info?[key] = value
    }

    override func valueForUndefinedKey(key: String!) -> AnyObject! {
        return info?[key]
    }

}
