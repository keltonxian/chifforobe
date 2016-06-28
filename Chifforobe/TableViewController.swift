//
//  TableViewController.swift
//  Chifforobe
//
//  Created by Kelton on 16/6/28.
//  Copyright © 2016年 xiankelton. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var names = [String]()
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        cell!.textLabel!.text = names[indexPath.row]
        return cell!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "\"Photo List\""
        tableView.registerClass(UITableViewCell.self,
            forCellReuseIdentifier: "Cell")
        let fileManager = NSFileManager.defaultManager()
        let listURL = fileManager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask) as [NSURL]
        let documentURL = listURL[0]
        var index = 1
        var path = documentURL.URLByAppendingPathComponent(String(format: "tempImage%d.jpg", index)).path
        while (fileManager.fileExistsAtPath(path!)) {
            names.append(path!)
            index += 1
            path = documentURL.URLByAppendingPathComponent(String(format: "tempImage%d.jpg", index)).path
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
