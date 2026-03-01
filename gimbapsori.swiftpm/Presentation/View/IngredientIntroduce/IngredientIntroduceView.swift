//
//  IngredientIntroduceView.swift
//  gimbapsori
//
//  Created by OpenAI Assistant on 2/20/26.
//

import SwiftUI

struct IngredientIntroduceView: View {
    let router: Router
    @StateObject private var audioController = GimbapAudioController()
    @State private var highlightedIngredientID: String?
    
    private var stages: [Ingredient] {
        Ingredient.palette
    }
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: "F7F1E9"), Color.white], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            Image("GimPopSori_Background")
                .resizable()
                .scaledToFill()
                .opacity(0.12)
                .ignoresSafeArea()
                .accessibilityHidden(true)
            
            ScrollView {
                VStack(spacing: 32) {
                    header
                    LazyVStack(spacing: 28) {
                        ForEach(Array(stages.enumerated()), id: \.element.id) { index, ingredient in
                            instrumentCard(index: index + 1, ingredient: ingredient)
                        }
                    }
                    Button(action: { router.pop() }) {
                        Text("Back to Main")
                            .font(.cursive(.bold, size: 32))
                            .foregroundColor(.black)
                            .padding(.horizontal, 50)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 44)
                                    .fill(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 44)
                                            .stroke(Color.black, lineWidth: 3)
                                    )
                            )
                    }
                    .padding(.bottom, 20)
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 40)
            }
        }
        .onDisappear {
            audioController.stop()
        }
    }
    
    private var header: some View {
        VStack(spacing: 10) {
            Text("Ingredient & Instrument Atlas")
                .font(.cursive(.bold, size: 60))
            Text("Learn the flavor, instrument, and tone color for every layer before composing your roll.")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.black.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 50)
        }
        .padding(.bottom, 12)
    }
    
    private func instrumentCard(index: Int, ingredient: Ingredient) -> some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 16) {
                if let ingredientAsset = ingredient.imageAssetName {
                    Image(ingredientAsset)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 60)
                        .padding(.trailing, 12)
                        .accessibilityHidden(true)
                }
                VStack(alignment: .leading, spacing: 12) {
                    Text("Ingredients")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.black.opacity(0.6))
                    Text(ingredient.name)
                        .font(.cursive(.bold, size: 40))
                    Text(ingredient.description)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black.opacity(0.8))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            HStack(alignment: .center, spacing: 28) {
                if let instrumentAsset = ingredient.instrumentImageAssetName {
                    Image(instrumentAsset)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 60)
                        .accessibilityHidden(true)
                }
                VStack(alignment: .leading, spacing: 12) {
                    Text("Instrument")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.black.opacity(0.6))
                    Text(ingredient.instrument)
                        .font(.system(size: 22, weight: .bold))
                    Text(instrumentInsight(for: ingredient.instrument))
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.black.opacity(0.7))
                        .fixedSize(horizontal: false, vertical: true)
                    Button(action: { playDemo(for: ingredient) }) {
                        HStack(spacing: 10) {
                            Image(systemName: highlightedIngredientID == ingredient.id && audioController.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                .font(.system(size: 28))
                            Text(highlightedIngredientID == ingredient.id && audioController.isPlaying ? "Pause demo" : "Play demo")
                                .font(.system(size: 17, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(
                            LinearGradient(colors: [ingredient.color, ingredient.accentColor], startPoint: .leading, endPoint: .trailing)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    }
                    .accessibilityLabel(Text(highlightedIngredientID == ingredient.id && audioController.isPlaying ? "데모 일시정지" : "데모 재생"))
                    .accessibilityHint(Text("\(ingredient.instrument) 소리를 미리 들어봅니다."))
                }
                Spacer()
            }
        }
        .padding(28)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 48, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 48)
                .stroke(highlightedIngredientID == ingredient.id ? ingredient.accentColor : Color.black.opacity(0.05), lineWidth: 2)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text("\(ingredient.name), 악기: \(ingredient.instrument)"))
        .accessibilityHint(Text("설명을 살펴보고 데모를 재생할 수 있습니다."))
    }
    
    private func stageBadge(number: Int) -> some View {
        VStack(spacing: 4) {
            Text("Stage")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.black.opacity(0.6))
            Text("\(number)")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.black)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(Color.white.opacity(0.85), in: RoundedRectangle(cornerRadius: 30, style: .continuous))
    }
    
    private func instrumentStack(ingredient: Ingredient) -> some View {
        VStack(spacing: 12) {
            Image("Instruments/\(ingredient.instrumentImageAssetName)")
                .resizable()
                .scaledToFit()
                .frame(width: 160, height: 160)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 8)
            if let ingredientAsset = ingredient.imageAssetName {
                Image(ingredientAsset)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 120)
            }
        }
        .frame(width: 180)
    }
    
    private func instrumentInsight(for instrument: String) -> String {
        switch instrument {
        case "Taepyeongso":
            return "A sharp reed fanfare that cuts through any ensemble—use it to announce new layers."
        case "Daegeum":
            return "A bamboo flute that breathes warm air between beats, stretching phrases across the roll."
        case "Haegeum":
            return "A bowed string voice capable of sliding, sighing, and bending pitch like caramel."
        case "Piri":
            return "Wooden reed tones that support the middle register and glue bright toppings together."
        case "Ajaeng":
            return "Scraped strings with gravelly resonance, adding grit like toasted sesame."
        case "Gayageum":
            return "Plucked zither sparkles that chatter quickly, filling gaps between heavier hits."
        case "Pyeonjong":
            return "Bells that shimmer after every strike, scattering brightness across the roll."
        default:
            return "Let this instrument set the mood for the next layer."
        }
    }
    
    private func playDemo(for ingredient: Ingredient) {
        if highlightedIngredientID == ingredient.id && audioController.isPlaying {
            audioController.pause()
            highlightedIngredientID = nil
        } else {
            audioController.prepareTracks(for: [ingredient], variant: .demo)
            audioController.play()
            highlightedIngredientID = ingredient.id
        }
    }
}

#Preview {
    IngredientIntroduceView(router: Router())
}
