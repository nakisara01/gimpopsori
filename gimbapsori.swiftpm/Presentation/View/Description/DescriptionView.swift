//
//  DescriptionView.swift
//  gimbapsori
//
//  Created by 나현흠 on 2/16/26.
//

import SwiftUI

struct DescriptionView: View {
    let router: Router
    @State private var history: [CompletedGimbap] = []
    
    var body: some View {
        ZStack {
            Image("GimPopSori_Background")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            
            Color.white.opacity(0.6)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    Text("Gimbap Sori Menu")
                        .font(.cursive(.bold, size: 72))
                        .foregroundColor(.black)
                        .padding(.top, 60)
                    
                    historySection
                    
                    Button(action: {
                        router.pop()
                    }, label: {
                        Text("Back to Making")
                            .foregroundColor(.black)
                            .font(.cursive(.bold, size: 48))
                            .padding(.horizontal, 80)
                            .padding(.vertical, 24)
                            .background(
                                RoundedRectangle(cornerRadius: 60)
                                    .fill(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 60)
                                            .stroke(Color.black, lineWidth: 6)
                                    )
                            )
                    })
                    .padding(.bottom, 80)
                }
                .padding()
            }
        }
        .onAppear {
            history = GimbapStorage.shared.load()
        }
    }
    
    private func infoRow(title: String, detail: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.cursive(.bold, size: 48))
            Text(detail)
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(.black.opacity(0.75))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var historySection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Rolled Gimbap Gallery")
                .font(.cursive(.bold, size: 54))
                .foregroundColor(.black)
            
            if history.isEmpty {
                Text("Roll your first gimbap to see it displayed here.")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.black.opacity(0.6))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 36, style: .continuous))
            } else {
                ForEach(history) { gimbap in
                    historyCard(for: gimbap)
                        .padding(.vertical, 4)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 48, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 48)
                .stroke(Color.black.opacity(0.1), lineWidth: 1)
        )
        .padding(.horizontal, 80)
    }
    
    private func historyCard(for gimbap: CompletedGimbap) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(gimbap.name)
                .font(.cursive(.bold, size: 30))
            HStack {
                Text(gimbap.createdAt, style: .date)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black.opacity(0.6))
                Text(gimbap.createdAt, style: .time)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black.opacity(0.6))
                Spacer()
            }
            HStack(alignment: .top, spacing: 24) {
                GimbapCrossSectionView(ingredients: gimbap.ingredients)
                    .frame(width: 140, height: 140)
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(gimbap.ingredients) { ingredient in
                        HStack(spacing: 8) {
                            Text(ingredient.icon)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(ingredient.name)
                                    .font(.system(size: 18, weight: .semibold))
                                Text(ingredient.instrument)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.black.opacity(0.6))
                            }
                        }
                    }
                }
                Spacer()
            }
        }
        .padding(20)
        .background(Color.white.opacity(0.85), in: RoundedRectangle(cornerRadius: 32, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 32)
                .stroke(Color.black.opacity(0.08), lineWidth: 1)
        )
    }
}

#Preview {
    DescriptionView(router: Router())
}
