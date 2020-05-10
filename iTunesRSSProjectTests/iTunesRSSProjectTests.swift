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
        if let url = URL(string: urlString) {
            fetchTop100Albums(url: url)
        }
    }
    
    func fetchTop100Albums(url: URL) {
        NetworkingManager.shared.getAlbums(url: url) { (albums, err) in
            if let error = err {
                // TODO: create alert in view somehow
            } else if let albumList = albums {
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
    
    var viewModel: MockViewModel!
    
    override func setUpWithError() throws {
        viewModel = MockViewModel(urlString: Bundle.main.path(forResource: "iTunesResultJSON", ofType: "json")!)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAlbumsCreated() {
        XCTAssertEqual(viewModel.getAlbumCount(), 10)
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
}
