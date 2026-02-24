//
//  GimbapCrossSectionView.swift
//  gimbapsori
//
//  Created by OpenAI Assistant on 2/20/26.
//

import SwiftUI

struct GimbapCrossSectionView: View {
    let ingredients: [Ingredient]
    
    var body: some View {
        GeometryReader { proxy in
            let step = 0.55 / max(CGFloat(ingredients.count), 1)
            let baseScale: CGFloat = 0.9
            ZStack {
                Circle()
                    .fill(Color(hex: "050505"))
                ForEach(Array(ingredients.enumerated()), id: \.offset) { index, ingredient in
                    Circle()
                        .fill(
                            LinearGradient(colors: [ingredient.color, ingredient.accentColor], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .scaleEffect(max(0.25, baseScale - CGFloat(index) * step))
                        .shadow(color: ingredient.color.opacity(0.25), radius: 6, x: 0, y: 4)
                }
                Circle()
                    .stroke(Color.white.opacity(0.45), lineWidth: 4)
            }
            .frame(width: proxy.size.width, height: proxy.size.width)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    GimbapCrossSectionView(ingredients: Ingredient.palette)
        .padding()
        .background(Color.gray.opacity(0.2))
}
