//
//  DasteBandi.swift
//  DakkeApp
//
//  Created by Sothesom on 26/12/1402.
//

import SwiftUI

struct DasteBandi: View {

    @State private var selectedTab: TabDaste?
    @Environment(\.colorScheme) private var scheme
    @State private var tabProgress: CGFloat = 0.5
    
    var body: some View {
        VStack(spacing: 15){
            HStack{
                
                Button(action: {}, label: {
                    Image(systemName: "line.3.horizontal.decrease")
                })
                
                Spacer()

                Button(action: {}, label: {
                    Image(systemName: "bell.badge")
                })
            }
            .font(.title2)
            .overlay{
                Text("دسته بندی")
                    .font(.title3.bold())
                
            }
            .foregroundStyle(.primary)
            .padding(15)
            
            CustomTabDast()
            
            GeometryReader{
                let size = $0.size
            
                ScrollView(.horizontal){
                    LazyHStack(spacing: 0){
                        SampleView(.blue)
                            .id(TabDaste.siyasi)
                            .containerRelativeFrame(.horizontal)
                    
                        SampleView(.red)
                            .id(TabDaste.varzeshi)
                            .containerRelativeFrame(.horizontal)
                    
                        SampleView(.black)
                            .id(TabDaste.ejtamae)
                            .containerRelativeFrame(.horizontal)
                    }
// با کمک اکسنشن کاستوم شده مقداره افست هارو در میاری تقسیم بر تعداد لیست ها میکنی موقیا هر لیست در میاد
                    .scrollTargetLayout()
                    .offsetX{ value in
                    // Converting Offset into Progress
                        let progress = -value / (size.width * CGFloat(TabDaste.allCases.count   - 1))
                        tabProgress = max(min(progress, 1),0)
                }
            }
                
        }
            .scrollPosition(id: $selectedTab)
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.paging)
            .scrollClipDisabled()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(.gray.opacity(0.1))

    }
    
    
// بنر بالای صفحه
    @ViewBuilder
    func CustomTabDast() -> some View {
        
        HStack(spacing: 0) {
            ForEach(TabDaste.allCases, id: \.rawValue){ tab in
                HStack(spacing: 10){
                    Image(systemName: tab.rawValue)
                    
                    Text(tab.title)
                        .font(.callout)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .contentShape(.capsule)
                .onTapGesture {
                    withAnimation(.snappy){
                        selectedTab = tab
                    }
                }
            }
        }
        .tabMask(tabProgress)
        // Scrollable Active Tab Indicator
        .background{
            GeometryReader{
                let size = $0.size
                let capsuleWidth = size.width / CGFloat(TabDaste.allCases.count)
                
                Capsule()
                    .fill(scheme == .dark ? .black : .white)
                    .frame(width: capsuleWidth)
                    .offset(x:tabProgress * (size.width - capsuleWidth))
            }
            
        }
        .background(.gray.opacity(0.1), in: .capsule)
        .padding(.horizontal, 15)
    }
    
// تابع لیست هر تب
    @ViewBuilder
    func SampleView(_ color: Color) -> some View{
        ScrollView(.vertical){
            LazyVGrid(columns: Array(repeating: GridItem(), count: 2), content: {
                ForEach(1...10, id: \.self){ _ in
                    RoundedRectangle(cornerRadius: 15)
                        .fill(color.gradient)
                        .overlay {
                            VStack(alignment: .leading){
                                Circle()
                                    .fill(.white.opacity(0.25))
                                    .frame(width: 50, height: 50)
                                
                                VStack(alignment: .leading, spacing: 6){
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(.white.opacity(0.25))
                                        .frame(width: 80, height: 8)
                                    
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(.white.opacity(0.25))
                                        .frame(width: 80, height: 8)
                                }
                                Spacer(minLength: 0)
                                
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(.white.opacity(0.25))
                                    .frame(width: 40, height: 8)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            .padding(15)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(height: 150)
                }
            })
            .padding(15)
        }
        .scrollIndicators(.hidden)
        .scrollClipDisabled()
        .mask{
            Rectangle()
                .padding(.bottom, -100)
        }
    }
}

#Preview {
    DasteBandi()
}
