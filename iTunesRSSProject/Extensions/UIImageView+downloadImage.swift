//
//  UIImageView+downloadImage.swift
//  CollectionViewProgrammatically
//
//  Created by mcs on 1/27/20.
//  Copyright © 2020 mcs. All rights reserved.
//

import UIKit

extension UIImageView {
    func downloadImageFrom(link: String, contentMode: UIView.ContentMode) {
        if let cachedImg = ImageCache.shared.getImage(with: link) {
            self.image = cachedImg
        } else if let url = URL(string: link) {
            NetworkingManager.shared.getImage(url: url) { (img, err) in
                if let error = err {
                    NotificationCenter.default.post(name: .fetchImageError, object: error.localizedDescription)
                } else if let image = img {
                    DispatchQueue.main.async { [weak self] in
                        self?.contentMode = contentMode
                        self?.image = image
                        ImageCache.shared.saveImage(with: link, image: image)
                    }
                }
            }
        }
    }
}
