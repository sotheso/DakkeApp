//
//  BanereAval.swift
//  DakkeApp
//
//  Created by Sothesom on 26/12/1402.
//

import SwiftUI

struct BanereAval: View {
    
    // View Custom
        @State private var items: [CoverFlowItem] = [ .init(image: Image("3")), .init(image: Image("4")), .init(image: Image("5")),.init(image: Image("6"))
        ]
        
    @State private var spacing: CGFloat = -70
    @State private var rotation: CGFloat = 60
// بازتاب
    @State private var enableReflection: Bool = true
            
    var body: some View {
        VStack{
            CoverFlowView(spacing: spacing, rotation: rotation, enableReflection: enableReflection ,itemWidth: 280, items: items){ item in
                ZStack {
                    NavigationLink(destination: DetailView(item: item)) {
                        item.image
                            .resizable()
                            .frame(width: 280, height: 200)
                            .scaledToFit()
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }
            }
            .frame(height: 200)
        }

    }
}

#Preview {
    BanereAval()
}

struct DetailView: View {
    let item: CoverFlowItem
    
    var body: some View {
        Text("Detail View for ")
    }
}
