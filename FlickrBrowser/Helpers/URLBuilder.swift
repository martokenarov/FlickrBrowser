//
//  URLBuilder.swift
//  FlickrBrowser
//
//  Created by Marto Kenarov on 4.03.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import Foundation

//https://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=f80b56ef10a6cc9d38c05d28d8103564&per_page=50&format=json&nojsoncallback=1

private let baseURL = "https://api.flickr.com/services/rest/?"
private let method = "flickr.photos.getRecent"
private let apiKey = "e3089e96135b1bbfbce78ee719212f75"
private let perPage = "100"
private let jsonFormat = "json"
private let nojsoncallback = "1"

class URLBuilder {
    static func getRecentPhotosURL() -> String {
        return baseURL + "method=\(method)&" + "api_key=\(apiKey)&" + "per_page=\(perPage)&" + "format=\(jsonFormat)&" + "nojsoncallback=\(nojsoncallback)"
    }
    
    static func getURLImage(for photo: Photo) -> String {
        // http://farm4.static.flickr.com/3221/2658147888_826edc8465.jpg
//        http://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}.jpg
//        or
//        http://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}_[mstzb].jpg

        return "https://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret)_m.jpg"
    }
}
