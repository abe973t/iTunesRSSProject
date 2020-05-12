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
        return viewModel.getAlbumCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? AlbumCell else {
            return UITableViewCell()
        }
        
        let album = viewModel.fetchAlbum(index: indexPath.row)
        cell.setup(album: album)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let album = viewModel.fetchAlbum(index: indexPath.row)
        let dVC = DetailViewController()
        dVC.detailView = DetailView(album: album)
        controller?.navigationController?.pushViewController(dVC, animated: true)
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
        
        createViewModel()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AlbumCell.self, forCellReuseIdentifier: "cell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createViewModel() {
        guard let url = URL(string: Constants.rssEndpoint) else {
            return
        }
        
        viewModel = ViewModel(session: NetworkingManager.shared, url: url)
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
