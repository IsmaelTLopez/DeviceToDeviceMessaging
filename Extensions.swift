//
//  Extensions.swift
//  DeviceToDevice
//
//  Created by Ismael Lopez on 6/28/17.
//  Copyright © 2017 Ismael Lopez. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCacheWithURLString(urlString: String){
        //clear image before loaded
        self.image = nil
        
        //check cached image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject){
            self.image = cachedImage as? UIImage
            return
        }
        
        //otherwise fireoff a new download
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil{
                print(error!)
                return
            }
            
            DispatchQueue.main.async(){
                
                if let downloadedImage = UIImage(data: data!) {
                    
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = downloadedImage
                }
            }
            
        }).resume()
    }
}
