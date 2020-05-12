//
//  ViewModel.swift
//  iTunesRSS
//
//  Created by mcs on 4/14/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import UIKit

class ViewModel {
    
    private var albums: [Results] = []
    private var session: NetworkingManagerProtocol!
    
    init(session: NetworkingManagerProtocol, url: URL) {
        self.session = session
        
        fetchTop100Albums(url: url)
    }
    
    func fetchTop100Albums(url: URL) {
        session.getAlbums(url: url) { (albums, err) in
            if let error = err {
                NotificationCenter.default.post(name: .fetchError, object: error.localizedDescription)
            } else if let albumList = albums?.feed?.results {
                self.albums = albumList
                NotificationCenter.default.post(name: .reload, object: nil)
            }
        }
    }
    
    func fetchAlbum(index: Int) -> AlbumViewModel {
        return AlbumViewModel(album: albums[index])
    }
    
    func getAlbumCount() -> Int {
        return albums.count
    }
}
