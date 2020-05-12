//
//  AlbumCell.swift
//  iTunesRSS
//
//  Created by mcs on 4/9/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import UIKit

class AlbumCell: UITableViewCell {
    
    let albumImg: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    let artistLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let albumLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .boldSystemFont(ofSize: 17)
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() {
        addSubview(albumImg)
        addSubview(albumLabel)
        addSubview(artistLabel)
        
        addConstraints()
    }

    func addConstraints() {
        let imgHeight = albumImg.heightAnchor.constraint(equalToConstant: 75)
        imgHeight.priority = UILayoutPriority(999)
        
        NSLayoutConstraint.activate([
            imgHeight,
            albumImg.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            albumImg.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            albumImg.widthAnchor.constraint(equalToConstant: 75),
            albumImg.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            albumLabel.topAnchor.constraint(equalTo: albumImg.topAnchor),
            albumLabel.leadingAnchor.constraint(equalTo: albumImg.trailingAnchor, constant: 10),
            albumLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            albumLabel.heightAnchor.constraint(equalToConstant: 40),
            
            artistLabel.bottomAnchor.constraint(equalTo: albumImg.bottomAnchor),
            artistLabel.leadingAnchor.constraint(equalTo: albumLabel.leadingAnchor),
            artistLabel.trailingAnchor.constraint(equalTo: albumLabel.trailingAnchor),
        ])
    }
    
    func setup(with album: AlbumViewModel) {
        albumImg.downloadImageFrom(link: album.fetchAlbumImgURL()?.absoluteString ?? "", contentMode: .scaleAspectFit)
        albumLabel.text = album.fetchAlbumName() ?? "N/A"
        artistLabel.text = album.fetchAlbumArtist() ?? "N/A"
    }
}
