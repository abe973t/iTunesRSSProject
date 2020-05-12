//
//  DetailView.swift
//  iTunesRSSProject
//
//  Created by mcs on 5/6/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import UIKit

class DetailView: View {
        
    var album: AlbumViewModel!
        
    let albumImg: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    let artistLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        return lbl
    }()
    
    let albumLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .boldSystemFont(ofSize: 20)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let releaseDateLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let copyrightLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        lbl.sizeToFit()
        return lbl
    }()
    
    let genreLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let iTunesBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("View in iTunes", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.addTarget(self, action: #selector(openLink), for: .touchUpInside)
        btn.layer.cornerRadius = 10
        return btn
    }()
    
    @objc func openLink() {
        guard let url = album.fetchAlbumLinkURL(), UIApplication.shared.canOpenURL(url) else {
            let alert = UIAlertController(title: "Error", message: "Cannot open link", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            controller?.present(alert, animated: true, completion: nil)
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    init(album: AlbumViewModel) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        self.album = album
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        albumImg.downloadImageFrom(link: album.fetchAlbumImgURL()?.absoluteString ?? "", contentMode: .scaleAspectFit)
        artistLabel.text = album.fetchAlbumArtist() ?? "Artist N/A"
        albumLabel.text = album.fetchAlbumName() ?? "Title N/A"
        releaseDateLabel.text = "Release Date: \(album.fetchAlbumReleaseDate() ?? "N/A")"
        copyrightLabel.text = "Copyright: \(album.fetchAlbumCopyright() ?? "N/A")"
                
        if let genres = album.fetchAlbumGenres() {
            let genreText = genres.reduce("Genre:") { $0 + " " + "\($1.name ?? " ")" }
            
            genreLabel.text = genreText
        }
        
        addViews()
    }
    
    func addViews() {
        addSubview(albumImg)
        addSubview(albumLabel)
        addSubview(artistLabel)
        addSubview(releaseDateLabel)
        addSubview(copyrightLabel)
        addSubview(genreLabel)
        addSubview(iTunesBtn)
        
        addConstraints()
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            albumImg.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            albumImg.leadingAnchor.constraint(equalTo: leadingAnchor),
            albumImg.trailingAnchor.constraint(equalTo: trailingAnchor),
            albumImg.heightAnchor.constraint(lessThanOrEqualToConstant: 400),
            
            albumLabel.topAnchor.constraint(equalTo: albumImg.bottomAnchor),
            albumLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            albumLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            albumLabel.heightAnchor.constraint(equalToConstant: 75),
            
            artistLabel.topAnchor.constraint(equalTo: albumLabel.bottomAnchor),
            artistLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            artistLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            artistLabel.heightAnchor.constraint(equalToConstant: 30),
            
            releaseDateLabel.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 20),
            releaseDateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            releaseDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            releaseDateLabel.heightAnchor.constraint(equalToConstant: 40),
            
            copyrightLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 10),
            copyrightLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            copyrightLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            genreLabel.topAnchor.constraint(equalTo: copyrightLabel.bottomAnchor, constant: 10),
            genreLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            genreLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            genreLabel.bottomAnchor.constraint(equalTo: iTunesBtn.topAnchor, constant: -10),
            
            iTunesBtn.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            iTunesBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            iTunesBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            iTunesBtn.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
