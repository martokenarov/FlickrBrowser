//
//  ApiClient.swift
//  FlickrBrowser
//
//  Created by Marto Kenarov on 4.03.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import Foundation

typealias GetResentPhotosResult = Result<RecentPhotos, FlickrBrowserError>
typealias GetRecentPhotosCompletion = (GetResentPhotosResult) -> Void

typealias Parameters = Dictionary<String, AnyObject>

protocol ApiClient {
    func getRecentPhotos(by url: String, completion: @escaping GetRecentPhotosCompletion)
}
