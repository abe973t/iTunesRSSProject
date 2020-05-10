//
//  MainView.swift
//  iTunesRSSProject
//
//  Created by mcs on 5/6/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import UIKit

extension MainView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getAlbumCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? AlbumCell else {
            return UITableViewCell()
        }
        
        if let album = viewModel.fetchAlbum(index: indexPath.row) {
            cell.setup(album: album, cache: viewModel.getCache())
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let album = viewModel.fetchAlbum(index: indexPath.row) {
            let dVC = DetailViewController()
            dVC.detailView = DetailView(album: album, cache: viewModel.getCache())
            controller?.navigationController?.pushViewController(dVC, animated: true)
        } else {
            let alert = UIAlertController(title: "Error", message: "Error fetching album", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            controller?.present(alert, animated: true, completion: nil)
        }
    }
}

class MainView: View {
    
    var viewModel: ViewModel!
    
    let tableView: UITableView = {
        let tblView = UITableView()
        tblView.translatesAutoresizingMaskIntoConstraints = false
        return tblView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        
        viewModel = ViewModel(urlString: Constants.rssEndpoint.rawValue)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AlbumCell.self, forCellReuseIdentifier: "cell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() {
        addSubview(tableView)
        
        addConstraints()
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
