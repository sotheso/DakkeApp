//
//  Tab.swift
//  DakkeApp
//
//  Created by Sothesom on 24/12/1402.
//

import SwiftUI

enum Tab: String, CaseIterable{
    
    case home = "house.fill"
    case category = "rectangle.3.group.fill"
    case favourite = "star.square.on.square.fill"
    case search = "magnifyingglass.circle.fill"
    
    var title: String{
        switch self {
        case .home:
            return "دکه"
        case .category:
            return "Category"
        case .favourite:
            return "Favourite"
        case .search:
            return "Search"
        }
    }
}

// Animated sf Tab model

struct AnimatedTab: Identifiable{
    var id: UUID = .init()
    var tab: Tab
    var isAnimating: Bool?
}
