//
//  Bindable.swift
//  FlickrBrowser
//
//  Created by Marto Kenarov on 4.03.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import Foundation

class Bindable<T> {
    typealias Listener = ((T) -> Void)
    var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ v: T) {
        self.value = v
    }
    
    func bind(_ listener: @escaping Listener) {
        self.listener = listener
    }
    
    func bindAndFire(_ listener: @escaping Listener) {
        self.listener = listener
        self.listener?(value)
    }
}
