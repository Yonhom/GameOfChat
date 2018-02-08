//
//  UIImageView+Cache.swift
//  GameOfChat
//
//  a image view extension with caching ability

//  Created by 徐永宏 on 2018/2/8.
//  Copyright © 2018年 徐永宏. All rights reserved.
//

import UIKit

// this cache object is a global variable, so it has the same life span as the app
let cache = NSCache<NSString, UIImage>()

extension UIImageView {
    func loadCachedImageWithUrl(imageUrlStr: String) {
        
        // before fetching image online, check cache first
        if let cachedImage = cache.object(forKey: imageUrlStr as NSString) {
            self.image = cachedImage
            return
        }
        
        // if there is no cached image matching a specific url str key, fetching a new one online
        let imageUrl = URL(string: imageUrlStr)!
        URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async(execute: {
                if let imageToBeCached = UIImage(data: data!) {
                    cache.setObject(imageToBeCached, forKey: imageUrlStr as NSString)
                    self.image = imageToBeCached
                }
            })
        }.resume()   // dont forget to call resume!!!
    }
}
