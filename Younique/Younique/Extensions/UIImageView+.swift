//
//  UIImageView+.swift
//  Younique
//
//  Created by Krishna Pradeep on 10/30/17.
//  Copyright © 2017 Krishna Pradeep. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func setImageWithUrl(_ urlString:String, placeHolderImage: UIImage?) {
        if let cachedImage = ImageCache.shared.getImageForKey(urlString) {
            self.image = cachedImage
            return
        }
 
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, reponse, error) in

                if let imageData = data, let image = UIImage(data: imageData), let imageUrl = reponse?.url?.absoluteString {
                    ImageCache.shared.saveImageWithKey(imageUrl, andImage: image)
                    if urlString == imageUrl {
                        DispatchQueue.main.async {
                            self.image = image
                        }
                        return
                    }
                }
                self.image = placeHolderImage
            }).resume()
        }
        else {
            self.image = nil
        }
    }
}
