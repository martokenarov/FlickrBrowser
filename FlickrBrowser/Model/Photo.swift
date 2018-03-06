//
//  Photo.swift
//  FlickrBrowser
//
//  Created by Marto Kenarov on 4.03.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import Foundation
import SwiftyJSON

//{
//    "id": "25739782627",
//    "owner": "67726991@N08",
//    "secret": "89a75414e0",
//    "server": "4701",
//    "farm": 5,
//    "title": "Tram Stop _CYC2018_1",
//    "ispublic": 1,
//    "isfriend": 0,
//    "isfamily": 0
//}

private let idKey = "id"
private let ownerKey = "owner"
private let secretKey = "secret"
private let serverKey = "server"
private let farmKey = "farm"
private let titleKey = "title"

struct Photo {
    var id: String
    var owner: String
    var secret: String
    var server: String
    var farm: Int
    var title: String
    var imageUrl: String
}

extension Photo {
    init?(with json:JSON) {
        guard let id = json[idKey].string, let secret = json[secretKey].string, let server = json[serverKey].string, let farm = json[farmKey].int else {
            return nil
        }
        
        self.id = id
        self.owner = json[ownerKey].stringValue
        self.secret = secret
        self.server = server
        self.farm = farm
        self.title = json[titleKey].stringValue
        
        self.imageUrl = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg"
    }
}
