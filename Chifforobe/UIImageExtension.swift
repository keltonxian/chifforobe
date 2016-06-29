//
//  UIImageExtension.swift
//  Chifforobe
//
//  Created by Kelton on 16/6/29.
//  Copyright © 2016年 xiankelton. All rights reserved.
//

import Foundation
import UIKit

private extension UIImage {
    private func createARGBBitmapContext(inImage: CGImageRef) -> CGContext {
        // get image's width, height.
        let pixelsWidth = CGImageGetWidth(inImage)
        let pixelsHeight = CGImageGetHeight(inImage)
        
        // declare the number of bytes per row.
        // each pixel in the bitmap is represented by 4 bytes.
        // 8 bits each of red, green, blue, alpha.
        let bitmapBytesPerRow = Int(pixelsWidth) * 4
//        let bitmapByteCount = bitmapBytesPerRow * Int(pixelsHeight)
        
        // use the generic RGB color space.
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // allocate memory for image data.
        // this is the destination in memory where any drawing to the bitmap context will be rendered.
        let bitmapData = UnsafeMutablePointer<UInt8>()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue)
        
        // create the bitmap context.
        // we want pre-multiplied ARGB, 8-bits per component.
        // regardless of what the source image format is (CMYK, Grayscale, and so on).
        // it will be converted over to the format specified here by CGBitmapContextCreate.
        let context = CGBitmapContextCreate(bitmapData, pixelsWidth, pixelsHeight, 8, bitmapBytesPerRow, colorSpace, bitmapInfo.rawValue)
        
        return context!
    }
    
    func sanitizePoint(point: CGPoint) {
        let inImage: CGImageRef = self.CGImage!
        let pixelsWidth = CGImageGetWidth(inImage)
        let pixelsHeight = CGImageGetHeight(inImage)
        let rect = CGRect(x: 0, y: 0, width: Int(pixelsWidth), height: Int(pixelsHeight))
        
        precondition(CGRectContainsPoint(rect, point), "CGPoint passed is not inside the rect of image.It will give wrong pixel and may crash.")
    }
}

// internal functions exposed.
// can be public
extension UIImage {
    typealias RawColorType = (newRedColor: UInt8, newGreenColor: UInt8, newBlueColor: UInt8, newAlphaValue: UInt8)
    
    // change the color of pixel at a certain point.
    // if you want more control,
    // try block based method to modify pixels.
    func setPixelColorAtPoint(point: CGPoint, color: RawColorType) -> UIImage? {
        self.sanitizePoint(point)
        let inImage: CGImageRef = self.CGImage!
        let context = self.createARGBBitmapContext(inImage)
        
        let pixelsWidth = CGImageGetWidth(inImage)
        let pixelsHeight = CGImageGetHeight(inImage)
        let rect = CGRect(x: 0, y: 0, width: Int(pixelsWidth), height: Int(pixelsHeight))
        
        // clear the context
        CGContextClearRect(context, rect)
        
        // draw the image to the bitmap context.
        // once we draw, the memory allocated for the context for rendering will then contain the raw image data in the specified color space.
        CGContextDrawImage(context, rect, inImage)
        
        // now we can get a pointer to the image data associated with the bitmap context.
        let data = CGBitmapContextGetData(context)
        let dataType = UnsafeMutablePointer<UInt8>(data)
        
        let offset = 4 * ((Int(pixelsWidth) * Int(point.y)) + Int(point.x))
        dataType[offset] = color.newAlphaValue
        dataType[offset + 1] = color.newRedColor
        dataType[offset + 2] = color.newGreenColor
        dataType[offset + 3] = color.newBlueColor
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue)
        
        let bitmapBytesPerRow = Int(pixelsWidth) * 4
//        let bitmapByteCount = bitmapBytesPerRow * Int(pixelsHeight)
        
        let finalContext = CGBitmapContextCreate(data, pixelsWidth, pixelsHeight, 8, bitmapBytesPerRow, colorSpace, bitmapInfo.rawValue)
        
        let imageRef = CGBitmapContextCreateImage(finalContext)
        
        return UIImage(CGImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
    }
    
    // get pixel color for a pixel in the image.
    func getPixelColorAtLocation(point: CGPoint) -> UIColor? {
        self.sanitizePoint(point)
        let inImage: CGImageRef = self.CGImage!
        let context = self.createARGBBitmapContext(inImage)
        
        let pixelsWidth = CGImageGetWidth(inImage)
        let pixelsHeight = CGImageGetHeight(inImage)
        let rect = CGRect(x: 0, y: 0, width: Int(pixelsWidth), height: Int(pixelsHeight))
        
        // clear the context
        CGContextClearRect(context, rect)
        
        // draw the image to the bitmap context.
        // once we draw, the memory allocated for the context for rendering will then contain the raw image data in the specified color space.
        CGContextDrawImage(context, rect, inImage)
        
        // now we can get a pointer to the image data associated with the bitmap context.
        let data = CGBitmapContextGetData(context)
        let dataType = UnsafeMutablePointer<UInt8>(data)
        
        let offset = 4 * ((Int(pixelsWidth) * Int(point.y)) + Int(point.x))
        let alphaValue = dataType[offset]
        let redColor = dataType[offset+1]
        let greenColor = dataType[offset+2]
        let blueColor = dataType[offset+3]
        
        let redFloat = CGFloat(redColor) / 255.0
        let greenFloat = CGFloat(greenColor) / 255.0
        let blueFloat = CGFloat(blueColor) / 255.0
        let alphaFloat = CGFloat(alphaValue) / 255.0
        
        return UIColor(red: redFloat, green: greenFloat, blue: blueFloat, alpha: alphaFloat)
        
        // when finished, release the context
        // free image data memory for the context
    }
    
    // get grayscale image from normal image.
    func getGrayScale() -> UIImage? {
        let inImage: CGImageRef = self.CGImage!
        let context = self.createARGBBitmapContext(inImage)
        
        let pixelsWidth = CGImageGetWidth(inImage)
        let pixelsHeight = CGImageGetHeight(inImage)
        let rect = CGRect(x: 0, y: 0, width: Int(pixelsWidth), height: Int(pixelsHeight))
        
        let bitmapBytesPerRow = Int(pixelsWidth) * 4
        let bitmapByteCount = bitmapBytesPerRow * Int(pixelsHeight)
        
        // clear the context
        CGContextClearRect(context, rect)
        
        // draw the image to the bitmap context.
        // once we draw, the memory allocated for the context for rendering will then contain the raw image data in the specified color space.
        CGContextDrawImage(context, rect, inImage)
        
        // now we can get a pointer to the image data associated with the bitmap context.
        let data = CGBitmapContextGetData(context)
        let dataType = UnsafeMutablePointer<UInt8>(data)
        
        for var x = 0; x < Int(pixelsWidth); x++ {
            for var y = 0; y < Int(pixelsHeight); y++ {
                let offset = 4*((Int(pixelsWidth) * Int(y)) + Int(x))
//                let alpha = dataType[offset]
                let red = dataType[offset + 1]
                let green = dataType[offset + 2]
                let blue = dataType[offset + 3]
                
                let avg = (UInt32(red) + UInt32(green) + UInt32(blue))/3
                
                dataType[offset + 1] = UInt8(avg)
                dataType[offset + 2] = UInt8(avg)
                dataType[offset + 3] = UInt8(avg)
            }
        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue)
        
        let finalContext = CGBitmapContextCreate(data, pixelsWidth, pixelsHeight, 8, bitmapBytesPerRow, colorSpace, bitmapInfo.rawValue)
        
        let imageRef = CGBitmapContextCreateImage(finalContext)
        
        return UIImage(CGImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
    }
    
    // define the closure.
    typealias ModifyPixelsClosure = (point: CGPoint, redColor: UInt8, greenColor: UInt8, blueColor: UInt8, alphaValue: UInt8)->(newRedColor: UInt8, newgreenColor: UInt8, newblueColor: UInt8,  newalphaValue: UInt8)
    
    // provide closure which will return new color value for pixel using any condition you want inside the closure.
    func applyOnPixels(closure: ModifyPixelsClosure) -> UIImage? {
        let inImage: CGImageRef = self.CGImage!
        let context = self.createARGBBitmapContext(inImage)
        
        let pixelsWidth = CGImageGetWidth(inImage)
        let pixelsHeight = CGImageGetHeight(inImage)
        let rect = CGRect(x: 0, y: 0, width: Int(pixelsWidth), height: Int(pixelsHeight))
        
        let bitmapBytesPerRow = Int(pixelsWidth) * 4
//        let bitmapByteCount = bitmapBytesPerRow * Int(pixelsHeight)
        
        // clear the context
        CGContextClearRect(context, rect)
        
        // draw the image to the bitmap context.
        // once we draw, the memory allocated for the context for rendering will then contain the raw image data in the specified color space.
        CGContextDrawImage(context, rect, inImage)
        
        // now we can get a pointer to the image data associated with the bitmap context.
        let data = CGBitmapContextGetData(context)
        let dataType = UnsafeMutablePointer<UInt8>(data)
        
        for var x = 0; x < Int(pixelsWidth); x++ {
            for var y = 0; y < Int(pixelsHeight); y++ {
                let offset = 4*((Int(pixelsWidth) * Int(y)) + Int(x))
                let alpha = dataType[offset]
                let red = dataType[offset + 1]
                let green = dataType[offset + 2]
                let blue = dataType[offset + 3]
                
                let (newRedColor, newGreenColor, newBlueColor, newAlphaValue) = closure(point: CGPointMake(CGFloat(x), CGFloat(y)), redColor: red, greenColor: green,  blueColor: blue, alphaValue: alpha)
                
                dataType[offset] = newAlphaValue
                dataType[offset + 1] = UInt8(newRedColor)
                dataType[offset + 2] = UInt8(newGreenColor)
                dataType[offset + 3] = UInt8(newBlueColor)
            }
        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue)
        
        let finalContext = CGBitmapContextCreate(data, pixelsWidth, pixelsHeight, 8, bitmapBytesPerRow, colorSpace, bitmapInfo.rawValue)
        
        let imageRef = CGBitmapContextCreateImage(finalContext)
        
        return UIImage(CGImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
    }
}
