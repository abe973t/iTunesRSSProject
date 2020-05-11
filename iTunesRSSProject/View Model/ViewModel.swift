//
//  ViewModel.swift
//  iTunesRSS
//
//  Created by mcs on 4/14/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import UIKit

protocol ViewModelProtocol {
    func fetchTop100Albums(url: URL)
    func fetchAlbum(index: Int) -> AlbumViewModel?
    func getCache() -> NSCache<NSString, UIImage>
    func getAlbumCount() -> Int?
}

class ViewModel: ViewModelProtocol {
    
    private var cache = NSCache<NSString, UIImage>()
    private var albums: [Results]?
    
    init(urlString: String) {
        if let url = URL(string: urlString) {
            fetchTop100Albums(url: url)
        }
    }
    
    func fetchTop100Albums(url: URL) {
        NetworkingManager.shared.getAlbums(url: url) { (albums, err) in
            if let error = err {
                NotificationCenter.default.post(name: .fetchError, object: error.localizedDescription)
            } else if let albumList = albums?.feed?.results {
                self.albums = albumList
                NotificationCenter.default.post(name: .reload, object: nil)
            }
        }
    }
    
    func fetchAlbum(index: Int) -> AlbumViewModel? {
        if let album = albums?[index] {
            return AlbumViewModel(album: album)
        } else {
            return nil
        }
    }
    
    func getCache() -> NSCache<NSString, UIImage> {
        return cache
    }
    
    func getAlbumCount() -> Int? {
        return albums?.count
    }
}
