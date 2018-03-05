//
//  AlamofireApiClient.swift
//  FlickrBrowser
//
//  Created by Marto Kenarov on 4.03.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import Foundation
import Alamofire
import Alamofire_SwiftyJSON

class AlamofireApiClient: ApiClient {
    func getRecentPhotos(by url: String, completion: @escaping (GetResentPhotosResult) -> Void) {
        Alamofire.request(url).validate().responseSwiftyJSON { responseJSON in
            switch responseJSON.result {
            case .success(let json):
                if let photos = RecentPhotos(with: json) {
                    completion(.success(payload: photos))
                } else {
                    completion(.failure(FlickrBrowserError(title: nil, description: "Error parsing JSON", code: .invalidResponse)))
                }
                break
            case .failure(let error):
                debugPrint(error.localizedDescription)
                completion(.failure(FlickrBrowserError(title: nil, description: error.localizedDescription, code: .invalidRequest)))
                
                break
            }
        }
    }
}
