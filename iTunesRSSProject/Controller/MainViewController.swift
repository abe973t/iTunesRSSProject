//
//  ViewController.swift
//  iTunesRSS
//
//  Created by mcs on 4/9/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
        
    let mainView = MainView()
    
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Top 100 Albums"
        navigationController?.navigationBar.backgroundColor = .systemBlue
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData), name: .reload, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(fetchError), name: .fetchError, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(fetchError), name: .fetchImageError, object: nil)
        
        mainView.createViewModel()
        mainView.controller = self
    }
    
    @objc func reloadTableData(_ notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.mainView.tableView.reloadData()
        }
    }
    
    @objc func fetchError(_ notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: "Error", message: notification.object as? String ?? "Error fetching content", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self?.present(alert, animated: true, completion: nil)
        }
    }
}
