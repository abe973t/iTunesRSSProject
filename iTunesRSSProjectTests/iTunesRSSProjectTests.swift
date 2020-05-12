//
//  iTunesRSSProjectTests.swift
//  iTunesRSSProjectTests
//
//  Created by mcs on 4/28/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import XCTest
@testable import iTunesRSSProject

class MockNetworkManager: NetworkingManagerProtocol {
    
    private init() {}
    static let shared = MockNetworkManager()
    
    func getAlbums(url: URL, completion: @escaping (iTunesResults?, Error?) -> ()) {
        do {
            let jsonData = try Data(contentsOf: url)
            let object = try JSONDecoder().decode(iTunesResults.self, from: jsonData)
            completion(object, nil)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getImage(url: URL, completion: @escaping (UIImage?, Error?) -> ()) {
        do {
            let jsonData = try Data(contentsOf: url)
            let object = UIImage(data: jsonData)
            completion(object, nil)
        } catch {
            completion(nil, error)
        }
    }
}

class iTunesRSSTests: XCTestCase {
    
    var viewModel: ViewModel!
    let cache = ImageCache.shared
    
    override func setUpWithError() throws {
        if let path = Bundle.main.path(forResource: "iTunesResultJSON", ofType: "json") {
            viewModel = ViewModel(session: MockNetworkManager.shared, url: URL(fileURLWithPath: path))
        } else {
            XCTFail("Could not locate path to create viewModel")
        }
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }
    
    // MARK: - View Model Tests
    func testAlbumsCreated() {
        XCTAssertTrue(viewModel.getAlbumCount() > 0)
    }
    
    func testFetchAlbum() {
        XCTAssertNotNil(viewModel.fetchAlbum(index: 0))
    }
    
    func testDecoding() throws {
        let jsonPath = try XCTUnwrap(Bundle.main.path(forResource: "iTunesResultJSON", ofType: "json"))
        let jsonPathURL = URL(fileURLWithPath: jsonPath)
        let jsonData = try Data(contentsOf: jsonPathURL)
        
        XCTAssertNoThrow(try JSONDecoder().decode(iTunesResults.self, from: jsonData))
    }
    
    // MARK: - Album View Model Test
    func testAlbumViewModel() {
        let album = viewModel.fetchAlbum(index: 0)
        XCTAssertNotNil(album.fetchAlbumArtist())
        XCTAssertNotNil(album.fetchAlbumName())
        XCTAssertNotNil(album.fetchAlbumGenres())
        XCTAssertNotNil(album.fetchAlbumImgURL())
        XCTAssertNotNil(album.fetchAlbumLinkURL())
        XCTAssertNotNil(album.fetchAlbumCopyright())
        XCTAssertNotNil(album.fetchAlbumReleaseDate())
    }
    
    // MARK: - Network Layer Tests
    func testGetAlbums() throws {
        let path = try XCTUnwrap(Bundle.main.path(forResource: "iTunesResultJSON", ofType: "json"))
        
        MockNetworkManager.shared.getAlbums(url: URL(fileURLWithPath: path)) { (results, err) in
            if let _ = err {
                XCTFail()
            } else {
                XCTAssertNotNil(results)
            }
        }
    }
    
    func testGetImage() throws {
        let imgPath = try XCTUnwrap(Bundle.main.path(forResource: "nt3", ofType: "png"))
        
        MockNetworkManager.shared.getImage(url: URL(fileURLWithPath: imgPath)) { (img, err) in
            if let _ = err {
                XCTFail()
            } else {
                XCTAssertNotNil(img)
            }
        }
    }
    
    // MARK: - Image Cache Test
    func testImageCache() throws {
        let imgPath = try XCTUnwrap(Bundle.main.path(forResource: "nt3", ofType: "png"))
        
        MockNetworkManager.shared.getImage(url: URL(fileURLWithPath: imgPath)) { [weak self] (img, err) in
            if let _ = err {
                XCTFail()
            } else if let image = img {
                self?.cache.saveImage(with: "testImage", image: image)
            }
        }
        
        XCTAssertNotNil(cache.getImage(with: "testImage"))
        XCTAssertNil(cache.getImage(with: "testImagel"))
    }
    
//    func testUIImageExtension() {
//        let image = UIImageView(frame: CGRect.zero)
//        image.downloadImageFrom(link: "testImage", contentMode: .scaleAspectFit)
//        XCTAssertNotNil(image.image)
//    }
}
