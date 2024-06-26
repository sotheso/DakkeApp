//
//  View_Extensions.swift
//  DakkeApp
//
//  Created by Sothesom on 26/12/1402.
//
//AS YOU CAN SEE, FOR EACH TAB MOVE, THE OFFSET INCREASES BY A MULTIPLE OF THE WIDTH, SO WHEN DIVIDING THE OFFSET BY THE TOTAL PAGING VIEW WIDTH (WHICH CAN BE CALCULATED BY MULTIPLYING THE WIDTH BY THE TOTAL TAB COUNT MINUS 1), THE PROGRESS CAN BE OBTAINED. THEN WE CAN USE THE PROGRESS TO MOVE THE TAB INDICATOR ON THE TAB BAR.

import SwiftUI

struct OffsetKey: PreferenceKey{
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension View {
    @ViewBuilder
    func offsetX(completion: @escaping (CGFloat) -> ()) -> some View{
        self
            .overlay {
                GeometryReader{
                    let minX = $0.frame(in: .scrollView(axis: .horizontal)).minX
                    
                    Color.clear
                        .preference(key: OffsetKey.self, value: minX)
                        .onPreferenceChange(OffsetKey.self, perform: completion)
            }
        }
    }
// tab bar masking
// انیمشن برای سلک کردن تب ها
// So what I'm going to do is use the mask modifier to simply highlight the currently scrolling content, and other content will be grayed out.
    
    @ViewBuilder
    func tabMask(_ tabProgress: CGFloat) -> some View{
        ZStack{
            self
                .foregroundStyle(.gray)
            
            self
                .symbolVariant(.fill)
                .mask{
                    GeometryReader{
                        let size = $0.size
                        let capsuleWidth = size.width / CGFloat(TabDaste.allCases.count)
                        
                        Capsule()
                            .frame(width: capsuleWidth)
                            .offset(x:tabProgress * (size.width - capsuleWidth))
                    }
                    
                }
        }
    }
}
