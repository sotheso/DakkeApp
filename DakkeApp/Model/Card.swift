//
//  Card.swift
//  DakkeApp
//
//  Created by Sothesom on 26/12/1402.
//

import SwiftUI

struct Card: Identifiable, Hashable, Equatable{
    var id: UUID = .init()
    var image: String
    var praviousOffset: CGFloat = 0
}



struct OffsetKeyCard: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension View{
    @ViewBuilder
    func offsetXCard(completion: @escaping (CGFloat) -> ()) -> some View {
        self
            .overlay {
                GeometryReader{
                    let minX = $0.frame(in: .scrollView).minX
                    Color.clear
                        .preference(key: OffsetKeyCard.self, value: minX)
                        .onPreferenceChange(OffsetKeyCard.self, perform: { value in
                            completion(value)
                        })
                }
            }
    }
}

// Card Array Extensions
extension [Card] {
    func indexOf(_ card: Card) -> Int {
        return self.firstIndex(of: card) ?? 0
    }
}
