//
//  ImageCacheLoader.swift
//  FlickrBrowser
//
//  Created by Marto Kenarov on 5.03.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

typealias ImageCacheLoaderCompletionHandler = ((UIImage) -> ())

class ImageCacheLoader {
    
    var cache: NSCache<NSString, UIImage>!
    
    init() {
        self.cache = NSCache()
    }
    // http://farm5.staticflickr.com/4663/25762157877_bff2e19143_m.jpg
    func obtainImageWithPath(imagePath: String, completionHandler: @escaping ImageCacheLoaderCompletionHandler) {
        if let image = self.cache.object(forKey: imagePath as NSString) {
            DispatchQueue.main.async {
                completionHandler(image)
            }
        } else {
            /* You need placeholder image in your assets,
             if you want to display a placeholder to user */
            let placeholder = UIImage(named: "no-image")
            DispatchQueue.main.async {
                completionHandler(placeholder!)
            }
            
            Alamofire.request(imagePath).responseData(completionHandler: { (response) in
                switch response.result {
                case .success(let data):
                    let img: UIImage! = UIImage(data: data)
                    self.cache.setObject(img, forKey: imagePath as NSString)
                    DispatchQueue.main.async {
                        completionHandler(img)
                    }
                    
                    break
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                    break
                }
            })
        }
    }
}
