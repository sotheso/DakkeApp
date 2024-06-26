//
//  CoverFlowView.swift
//  DakkeApp
//
//  Created by Sothesom on 25/12/1402.
//

import SwiftUI

// Custom View
struct CoverFlowView<Content : View, Item: RandomAccessCollection>: View where Item.Element: Identifiable {
    
    var spacing : CGFloat = 0
    var rotation: Double
    var enableReflection: Bool = false
    var itemWidth: CGFloat
    var items: Item
    var content : (Item.Element) -> Content

    var body: some View {
        
        GeometryReader{
            let size = $0.size
            
            ScrollView(.horizontal){
                LazyHStack(spacing: 5){
                    ForEach(items){ item in
                        content(item)
                            .frame(width: itemWidth)
                            .reflection(enableReflection)
                            .visualEffect { content, geometryProxy in
                                content
                                    .rotation3DEffect(.init(degrees: rotation(geometryProxy)), axis: (x:0 , y:1, z:0), anchor: .center)
                            }
                            .padding(.trailing, item.id == items.last?.id ? 0 : spacing)
                    }
                }
                .padding(.horizontal, (size.width - itemWidth) / 2)
                .scrollTargetLayout()
            }
            // سکته برای ویوی هر بنر
            .scrollTargetBehavior(.viewAligned)
            // هاید کردن این دست خر پایین اسکرول
            .scrollIndicators(.hidden)
            .scrollClipDisabled()
        }
    }
    
// تابع ریاضی محاسبه این موقعیت های بنر ها نسبت بهم
    func rotation(_ proxy: GeometryProxy) -> Double {
            let scrollViewWidth = proxy.bounds(of: .scrollView(axis: .horizontal))?.width ?? 0
            let midX = proxy.frame(in: .scrollView(axis: .horizontal)).midX
    // Converting into progress
            let progress = midX / scrollViewWidth
    // Limiting Progress between 0-1
            let cappedProgress = max(min(progress, 1), 0)
            let degree = cappedProgress * (rotation * 2)
            return rotation - degree
    }
}

    
 

// Cover flow item model
struct CoverFlowItem: Identifiable{
    let id: UUID = .init()
    let image: Image 
}


// تابع بازتاب
fileprivate extension View {
    @ViewBuilder
    func reflection(_ added: Bool) -> some View {
        self
            .overlay {
                if added {
                    GeometryReader{
                        let size = $0.size
                        
                        // وارونه کردن
                        self
                            .scaleEffect(y: -1)
                            .mask{
                                Rectangle()
                                    .fill(
                                        .linearGradient(colors: [.white, .white.opacity(0.7), .white.opacity(0.5), .white.opacity(0.3), .white.opacity(0.1), .white.opacity(0)] + Array(repeating: Color.clear, count: 10), startPoint: .top, endPoint: .bottom)
                                    )
                            }
                            .offset(y: size.height + 5)
                            .opacity(0.5)
                    }
                }
            }
        }
    }


#Preview {
    ContentView()
}

