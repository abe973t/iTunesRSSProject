//
//  DetailViewController.swift
//  iTunesRSS
//
//  Created by mcs on 4/9/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var detailView: DetailView!

    override func loadView() {
        view = detailView
        detailView.setupViews()
    }
}
