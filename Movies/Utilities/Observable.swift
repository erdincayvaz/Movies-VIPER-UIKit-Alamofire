//
//  Observable.swift
//  Movies
//
//  Created by Erdinç Ayvaz on 17.08.2022.
//

import Foundation

class Observable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?) -> ())?
    
    func bind(observer: @escaping (T?) -> ()) {
        self.observer = observer
    }
    
}
