//
//  MainViewController.swift
//  Chifforobe
//
//  Created by Kelton on 16/6/28.
//  Copyright © 2016年 xiankelton. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.ptions: NSDirectoryEnumerationOptions())
        
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.initPhotos()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
