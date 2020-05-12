//
//  AlbumViewModel.swift
//  iTunesRSSProject
//
//  Created by mcs on 5/6/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import Foundation

struct AlbumViewModel {
    private var album: Results
    
    init(album: Results) {
        self.album = album
    }
    
    func fetchAlbumName() -> String? {
        return album.name
    }
    
    func fetchAlbumArtist() -> String? {
        return album.artistName
    }
    
    func fetchAlbumReleaseDate() -> String? {
        return album.releaseDate
    }
    
    func fetchAlbumCopyright() -> String? {
        return album.copyright
    }
    
    func fetchAlbumImgURL() -> URL? {
        return album.artworkUrl100
    }
    
    func fetchAlbumLinkURL() -> URL? {
        return album.url
    }
    
    func fetchAlbumGenres() -> [Genres]? {
        return album.genres
    }
}
