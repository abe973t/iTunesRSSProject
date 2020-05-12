//
//  NetworkingManagerViewController.swift
//  NetworkingManager
//
//  Created by mcs on 1/27/20.
//  Copyright © 2020 mcs. All rights reserved.
//

import UIKit

protocol NetworkingManagerProtocol {
    func getAlbums(url: URL, completion: @escaping (iTunesResults?, Error?) -> ())
    func getImage(url: URL, completion: @escaping (UIImage?, Error?) -> ())
}

class NetworkingManager: NetworkingManagerProtocol {
    private init() {}
    static let shared = NetworkingManager()
    
    func getAlbums(url: URL, completion: @escaping (iTunesResults?, Error?) -> ()) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
            }

            if let data = data {
                do {
                   let object = try JSONDecoder().decode(iTunesResults.self, from: data)
                   completion(object, nil)
                } catch {
                   print(error.localizedDescription)
                }
            }
        }.resume()
    }
    
    func getImage(url: URL, completion: @escaping (UIImage?, Error?) -> ()) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
       
        URLSession.shared.dataTask(with: request) {data, response, error in
            if let error = error {
                completion(nil, error)
            }
            
            if let data = data, let img = UIImage(data: data) {
                completion(img, nil)
            }
        }.resume()
    }
}
