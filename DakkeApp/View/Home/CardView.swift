//
//  CardView.swift
//  DakkeApp
//
//  Created by Sothesom on 26/12/1402.
//

import SwiftUI

struct CardView: View {
    
    @State private var cards: [Card] = [ .init(image: "01"), .init(image: "02"), .init(image: "03"), .init(image: "04"), .init(image: "05"), .init(image: "06")
    ]
    
    var body: some View {
        VStack{
            GeometryReader {
                let size = $0.size
                
                ScrollView(.horizontal){
                    HStack(spacing: 10){
                        ForEach(cards){ card in
                            NavigationLink(destination: DetailView2(item: card)) {
                                CardsView(card)
                                    .frame(height: 100)
                            }
                        }
                    }
                    .padding(.trailing, size.width - 180)
                    .scrollTargetLayout()
                }
    
                .scrollTargetBehavior(.viewAligned)
                .scrollIndicators(.hidden)
                .clipShape(.rect(cornerRadius: 25))
                
            }
            .padding(.horizontal, 15)
            .padding(.top, 30)
        }
    }
// ٰCards View
    func CardsView(_ card: Card) -> some View {
        GeometryReader{ proxy in
            let size = proxy.size
            let minX = proxy.frame(in: .scrollView).minX
// 190: 180 - Card Width; 10 - Spacing
            let reducingWidth = (minX / 190) * 100
            let cappedWidth = min(reducingWidth, 130)
        
// In order to reduce the size of the card, I'm going to turn each card into a progress value that ranges from 0 to 130 and is based on the MinX Value.
// Later, I'm using this progress value to reduce the card width since the first card will have a zero minX value, thus the first card will be at its full width, and the subsequent cards widths will alter, thus their mint values varying.
// Only the size of the view inside the container has changed, and since the width of each container is the same as 180, we must relocate all the views precisely to match the resizing. Think about the following illustration: Since the first view did not change in size at all, there is no offset that needs to be adjusted for the second view.Now that the second view has been shrunk by 100 points, the third view must be advanced by 100 points to match the second view's size change. Because of this, I added a variable named previousOffset to the "Card Model" to keep track of the previous view offset to match the current view position.
// All of the views inside the scrollview will follow this same pattern.
            
            let frameWidth = max(size.width - (minX > 0 ? cappedWidth : -cappedWidth), 0)

            Image(card.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size.width, height: size.height)
                .frame(width: frameWidth)
                .clipShape(.rect(cornerRadius: 25))
                .offset(x: minX > 0 ? 0 : -cappedWidth)
                .offset(x: -card.praviousOffset)
        }
        .frame(width: 200, height: 200)
        .offsetXCard{ offset in
            let reducingWidth = (offset / 190) * 100
            let index = cards.indexOf(card)
            
            if cards.indices.contains(index + 1){
                cards[index + 1].praviousOffset = (offset < 0 ? 0 : reducingWidth)
            }

        }
    }
}
#Preview {
    CardView()
}

struct DetailView2: View {
    let item: Card
    
    var body: some View {
        Text("Detail View for ")
    }
}
