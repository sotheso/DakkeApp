//
//  MAnchorKey.swift
//  DakkeApp
//
//  Created by Sothesom on 04/04/1403.
//

import SwiftUI

// For Reading the Source and Destination View Bounds for our Custom Matched Geometry Effect
struct MAnchorKey: PreferenceKey {
    static var defaultValue: [String: Anchor<CGRect>] = [:]
    static func reduce(value: inout [String : Anchor<CGRect>], nextValue: () -> [String : Anchor<CGRect>]) {
        value.merge(nextValue()) {$1}
    }
}
