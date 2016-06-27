//
//  ViewController.swift
//  CameraSwift
//
//  Created by xiankelton on 6/25/16.
//  Copyright © 2016 xiankelton. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NSFileManagerDelegate {

    @IBOutlet weak var btnTakePhoto: UIButton!
    @IBOutlet weak var btnPickPhoto: UIButton!
    @IBOutlet weak var btnSaveLocal: UIButton!
    @IBOutlet weak var btnSaveAlbum: UIButton!
    @IBOutlet weak var photoView: UIImageView!
    
    
    @IBAction func actionTakePhoto(sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .Camera
        presentViewController(picker, animated: true, completion: nil)
    }
    
    @IBAction func actionPickPhoto(sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        presentViewController(picker, animated: true, completion: nil)
    }
    
    @IBAction func actionSaveLocal(sender: UIButton) {
        let imageData = UIImageJPEGRepresentation(photoView.image!, 0.6)
        let compressedJPGImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
        
        let fileManager = NSFileManager.defaultManager()
        fileManager.delegate = self
        
        let listURL = fileManager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask) as [NSURL]
        let documentURL = listURL[0]
        let imageURL = documentURL.URLByAppendingPathComponent("tempImage.jpg")
        
        let isSuccess = imageData?.writeToURL(imageURL, atomically: true)
        
        let msg = true == isSuccess ? "Save local success" : "Save local fail"
        let alert = UIAlertController(title: "Tip", message:msg, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
        self.presentViewController(alert, animated: true){}
        
//        let documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
//        let writePath = documents.stringByAppendingPathComponent("file.plist")
//        let array = NSArray(contentsOfFile: filePath)
//        if let array = array {
//            array.writeToFile(filePath, atomically: true)
//        }
//        
//        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
//        let documentsDirectory: String = paths[0]
//        NSLog("documentsDirectory[%s]", documentsDirectory)
//        let strRet: String = documentsDirectory.utf8
//        NSLog("path[%s]", strRet)
//        const char * strRet = [documentsDirectory UTF8String];
//        strRet.append("/");
//        imageData?.writeToFile("", atomically: true)
    }
    
    @IBAction func actionSaveAlbum(sender: UIButton) {
        let imageData = UIImageJPEGRepresentation(photoView.image!, 0.6)
        let compressedJPGImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
        
//        let alert = UIAlertView(title: "Wow",
//            message: "Your image has been saved to Photo Library!",
//            delegate: nil,
//            cancelButtonTitle: "Ok")
//        alert.show()
        let alert = UIAlertController(title: "Tip", message:"Your image has been saved to Photo Library!", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
        self.presentViewController(alert, animated: true){}
        
//        let rootVC = UIApplication.sharedApplication().keyWindow?.rootViewController
//        rootVC?.presentViewController(alert, animated: true){}
    }
    
    func setImageToView(imageView: UIImageView, image: UIImage) {
        imageView.image = image
//        toImageView.frame = CGRectMake(toImageView.frame.origin.x, toImageView.frame.origin.y, img.size.width, img.size.height)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image: UIImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        setImageToView(photoView, image: image)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        let fileManager = NSFileManager.defaultManager()
//        fileManager.delegate = self
//        
//        let listURL = fileManager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask) as [NSURL]
//        let documentURL = listURL[0]
//        let imageURL = documentURL.URLByAppendingPathComponent("tempImage.jpg")
//        
//        let contents = fileManager.contentsOfDirectoryAtURL(imageURL, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

