//
//  iTunesRSSProjectTests.swift
//  iTunesRSSProjectTests
//
//  Created by mcs on 4/28/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import XCTest
@testable import iTunesRSSProject

class MockViewModel: ViewModelProtocol {
    private var cache = NSCache<NSString, UIImage>()
    private var albums: [Results]?
    
    init(urlString: String) {
        fetchTop100Albums(url: URL(fileURLWithPath: urlString))
    }
    
    func fetchTop100Albums(url: URL) {
        NetworkingManager.shared.getAlbums(url: url) { (albums, err) in
            if let albumList = albums?.feed?.results {
                self.albums = albumList
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

class iTunesRSSTests: XCTestCase {
    
    var viewModel: ViewModelProtocol!
    
    override func setUpWithError() throws {
        if let path = Bundle.main.path(forResource: "iTunesResultJSON", ofType: "json") {
            viewModel = MockViewModel(urlString: path)
        } else {
            XCTFail("Could not locate path to create viewModel")
        }
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }
    
    // MARK: - View Model Tests
    func testAlbumsCreated() {
        XCTAssertNotNil(viewModel.getAlbumCount())
    }
    
    func testFetchAlbum() {
        XCTAssertNotNil(viewModel.fetchAlbum(index: 0))
    }
    
    func testCacheObjectExists() {
        XCTAssertNotNil(viewModel.getCache())
    }
    
    func testDecoding() throws {
        let jsonPath = try XCTUnwrap(Bundle.main.path(forResource: "iTunesResultJSON", ofType: "json"))
        let jsonPathURL = URL(fileURLWithPath: jsonPath)
        let jsonData = try Data(contentsOf: jsonPathURL)
        
        XCTAssertNoThrow(try JSONDecoder().decode(iTunesResults.self, from: jsonData))
    }
    
    // MARK: - Album View Model Test
    func testAlbumViewModel() {
        if let album = viewModel.fetchAlbum(index: 0) {
            XCTAssertNotNil(album.fetchAlbumArtist())
            XCTAssertNotNil(album.fetchAlbumName())
            XCTAssertNotNil(album.fetchAlbumGenres())
            XCTAssertNotNil(album.fetchAlbumImgURL())
            XCTAssertNotNil(album.fetchAlbumLinkURL())
            XCTAssertNotNil(album.fetchAlbumCopyright())
            XCTAssertNotNil(album.fetchAlbumReleaseDate())
        } else {
            XCTFail("Could not fetch album")
        }
    }
    
    // MARK: - Network Layer Tests
    func testGetAlbums() throws {
        let path = try XCTUnwrap(Bundle.main.path(forResource: "iTunesResultJSON", ofType: "json"))
        
        NetworkingManager.shared.getAlbums(url: URL(fileURLWithPath: path)) { (results, err) in
            if  let _ = err {
                
            } else {
                XCTAssertNotNil(results)
            }
        }
    }
    
    func testGetImage() throws {
        let imgPath = try XCTUnwrap(Bundle.main.path(forResource: "nt3", ofType: "png"))
        
        NetworkingManager.shared.getImage(url: URL(fileURLWithPath: imgPath)) { (img, err) in
            if let _ = err {
                XCTFail()
            } else {
                XCTAssertNotNil(img)
            }
        }
    }
}
