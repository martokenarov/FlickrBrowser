//
//  PhotoCollectionViewCell.swift
//  FlickrBrowser
//
//  Created by Marto Kenarov on 5.03.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    var viewModel: PhotoCollectionCellViewModel? {
        didSet {
            bindViewModel()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
    }
    
    private func bindViewModel() {
        title.text = viewModel?.title
    }
}
