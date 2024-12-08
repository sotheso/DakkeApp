//
//  ViewState.swift
//  DakkeApp
//
//  Created by Sothesom on 18/09/1403.
//

import Foundation

enum ViewState<T> {
    case idle
    case loading
    case data(T)
    
    var isLoading : Bool {
        if case .loading = self {
            return true
        }
        return false
    }
    
    var data: T? {
        if case .data(let t) = self {
            return t
        }
        return nil
    }
}
