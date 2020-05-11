//
//  ImageCache.swift
//  iTunesRSSProject
//
//  Created by mcs on 5/11/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import UIKit

final class ImageCache {
    static let shared = ImageCache()
    private var cache = NSCache<NSString, NSData>()
    
    private init() {}
    
    func saveImage(with url: String, image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 1) else {
            return
        }
        
        self.cache.setObject(imageData as NSData, forKey: url as NSString)
    }
    
    func getImage(with url: String) -> UIImage? {
        guard let imageData = self.cache.object(forKey: url as NSString) else {
            return nil
        }
        
        return UIImage(data: imageData as Data)
    }
}
