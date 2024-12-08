//
//  accuntView.swift
//  DakkeApp
//
//  Created by Sothesom on 17/09/1403.
//

import SwiftUI

struct accuntView: View {
    var body: some View {
        ScrollView{
            VStack{
                imageView()
                
                GeometryReader { geo in
                    let minY = geo.frame(in: .global).minY
                    
                    HStack(spacing: 10) {
                        Button {
                            
                        } label: {
                            Label("message", systemImage: "message")
                                .font(.callout)
                                .bold()
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 45)
                                .background(.black, in: RoundedRectangle(cornerRadius: 20))
                        }
                        Button(action:{}) {
                            Image(uiImage: .telegram)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 14, height: 14)
                                .padding()
                                .background(.black, in: Circle())
                        }
                        Button(action:{}) {
                            Image(uiImage: .instagram)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 14, height: 14)
                                .padding()
                                .background(.white, in: Circle())
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .offset(y: max(60 - minY, 0))
                }
                .padding(.horizontal)
                .offset(y: -44)
                .zIndex(1)
                
                // Here we creat Grid View
                GradView()
                
            }
        }
    }
}

struct GradView: View {
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
            ForEach(0..<25) { item in
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 180, height: 220)
                    .foregroundStyle(.ultraThinMaterial)
            }
        }
        .padding(.horizontal, 10)
    }
}

@ViewBuilder
func imageView() -> some View {
    GeometryReader { geo in
        let minY = geo.frame(in: .global).minY
        let isScrolling = minY > 0
        
        VStack{
            Image(.wallpaperflare)
                .resizable()
                .scaledToFill()
                .frame(height: isScrolling ? 140 + minY : 180)
                .clipped()
                .offset(y: isScrolling ? -minY : 0)
                .blur(radius: isScrolling ? 0 + minY / 80 : 0)
                .overlay(alignment: .bottom) {
                    ZStack {
                        Image(.profile)
                            .resizable()
                            .scaledToFit()
                        
                        Circle().stroke(lineWidth: 3)
                    }
                    .frame(width: 110, height: 110)
                    .clipShape(Circle())
                    .offset(y: 50)
                    .offset(y: isScrolling ? -minY : 10)
                }
            
            Group {
                VStack(spacing: 6){
                    Text("Sothesom")
                        .bold().font(.title)
                    
                    Text("iOS Developer in IRI,Tehran. University of Tehran, SwiftUI and UIKit in Narmak and str.Arshi")
                        .font(.callout)
                        .multilineTextAlignment(.center)
                        .frame(width: geo.size.width)
                        .lineLimit(3)
                        .fixedSize()
                }
                .offset(y: isScrolling ? -minY : 0)
            }
            .padding(.vertical, 60)
        }
    }
    .frame(height: 395)
}
#Preview {
    accuntView()
}
