//
//  TableViewController.swift
//  Chifforobe
//
//  Created by Kelton on 16/6/28.
//  Copyright © 2016年 xiankelton. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let appDelegate =
        UIApplication.shared.delegate as! AppDelegate
        return appDelegate.getPhotos().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        let appDelegate =
        UIApplication.shared.delegate as! AppDelegate
        let photo = appDelegate.getPhotos()[indexPath.row]
//        cell!.textLabel!.text = photo.valueForKey("path") as! String?
        let data = photo.value(forKey: "data") as! Data
        let image = UIImage(data: data)
        let imageView = UIImageView(image: image)
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        imageView
        cell?.addSubview(imageView)
        return cell!
    }
    
    func addPath(_ path: String) {
//        //1
//        let appDelegate =
//        UIApplication.sharedApplication().delegate as! AppDelegate
//        
//        let managedContext = appDelegate.managedObjectContext
//        
//        //2
//        let entity =  NSEntityDescription.entityForName("Photo",
//            inManagedObjectContext:
//            managedContext)
//        
//        let photo = NSManagedObject(entity: entity!,
//            insertIntoManagedObjectContext:managedContext)
//        
//        //3
//        photo.setValue(path, forKey: "path")
//        
//        //4
//        do {
//            try managedContext.save()
//        } catch let error {
//            print("Could not cache the response \(error)")
//        }
//        //5
//        appDelegate.getPhotos().append(photo)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "\"Photo List\""
        tableView.register(UITableViewCell.self,
            forCellReuseIdentifier: "Cell")
//        let fileManager = NSFileManager.defaultManager()
//        let listURL = fileManager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask) as [NSURL]
//        let documentURL = listURL[0]
//        var index = 1
//        var path = documentURL.URLByAppendingPathComponent(String(format: "tempImage%d.jpg", index)).path
//        while (fileManager.fileExistsAtPath(path!)) {
////            names.append(path!)
//            addPath(path!)
//            index += 1
//            path = documentURL.URLByAppendingPathComponent(String(format: "tempImage%d.jpg", index)).path
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
