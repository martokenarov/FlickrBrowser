//
//  PhotosViewModel.swift
//  FlickrBrowser
//
//  Created by Marto Kenarov on 4.03.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import Foundation

class PhotosViewModel {
    
    public let photoCells = Bindable([PhotoCollectionCellViewModel]())
    public var onShowError: ((_ message: String) -> Void)?
    
    private var apiClient = AlamofireApiClient()
    
    var showLoadingHud: Bindable = Bindable(false)
    
    public func getPhotos() {
        showLoadingHud.value = true
        
        apiClient.getRecentPhotos(by: URLBuilder.getRecentPhotosURL()) { [weak self] result  in
            debugPrint(result)
            
            self?.showLoadingHud.value = false
            
            switch result {
            case .success(let payload):
                self?.populateCells(photos: payload.photos)
                break
            case.failure(let error):
                
                if let error = error {
                    self?.onShowError?(error.localizedDescription)
                } else {
                    self?.onShowError?("Something went wrong!")
                }
                
                break
            }
        }
    }
    
    private func populateCells(photos: [Photo]) {
        self.photoCells.value = photos.map({ (photo) -> PhotoCollectionCellViewModel in
            return PhotoCollectionCellViewModel(photo.title, imageURL: photo.imageUrl)
        })
    }
}
