//
//  ImageCache.swift
//  Younique
//
//  Created by Krishna Pradeep on 10/30/17.
//  Copyright © 2017 Krishna Pradeep. All rights reserved.
//

import UIKit

class ImageCache: NSCache<AnyObject, AnyObject> {
    static let shared = ImageCache()
    
    var imageCache : NSCache<AnyObject, AnyObject>!
    
    override init() {
        self.imageCache = NSCache<AnyObject, AnyObject>()
    }
    
    func saveImageWithKey(_ key: String, andImage image: UIImage) {
        self.imageCache.setObject(image, forKey: key as AnyObject)
    }
    
    func getImageForKey(_ key: String) -> UIImage? {
        return self.imageCache.object(forKey: key as AnyObject) as? UIImage
    }
}
