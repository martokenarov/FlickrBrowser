//
//  PhotoCollectionCellViewModel.swift
//  FlickrBrowser
//
//  Created by Marto Kenarov on 5.03.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//


class PhotoCollectionCellViewModel {
    var title: String
    var imageURL: String
    
    init(_ title: String, imageURL: String) {
        self.title = title
        self.imageURL = imageURL
    }
}
