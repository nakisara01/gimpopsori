//
//  IngredientUnlockView.swift
//  gimbapsori
//
//  Created by OpenAI Assistant on 2/21/26.
//

import SwiftUI

struct IngredientUnlockView: View {
    let ingredient: Ingredient
    let isNext: Bool
    let onUnlock: () -> Void
    let onClose: () -> Void
    @StateObject private var audioController = GimbapAudioController()
    private let scene: IngredientStoryScene
    
    init(ingredient: Ingredient, isNext: Bool, onUnlock: @escaping () -> Void, onClose: @escaping () -> Void) {
        self.ingredient = ingredient
        self.isNext = isNext
        self.onUnlock = onUnlock
        self.onClose = onClose
        self.scene = IngredientStoryScene.allScenes.first { $0.ingredient.id == ingredient.id } ?? IngredientStoryScene(ingredient: ingredient, dialogues: [], instrumentInsight: "")
    }
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: "F7F1E9"), Color.white], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            Image("GimPopSori_Background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .opacity(0.1)
            
            ScrollView {
                VStack(spacing: 26) {
                    header
                    heroSection
                    instrumentSection
                    pairingSection
                    actionButtons
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 30)
            }
        }
        .onDisappear {
            audioController.stop()
        }
    }
    
    private var header: some View {
        VStack(spacing: 8) {
            Text("Unlock \(ingredient.name)")
                .font(.cursive(.bold, size: 48))
            Text("Instrument: \(ingredient.instrument)")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.black.opacity(0.65))
        }
        .frame(maxWidth: .infinity)
    }
    
    private var heroSection: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 20) {
                Group {
                    if let asset = ingredient.imageAssetName {
                        Image(asset)
                            .resizable()
                            .scaledToFit()
                    } else {
                        Text(ingredient.icon)
                            .font(.system(size: 100))
                    }
                }
                .frame(width: 180, height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: 8)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(ingredient.name)
                        .font(.cursive(.bold, size: 42))
                    Text(ingredient.description)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black.opacity(0.75))
                }
            }
            Button(action: toggleDemo) {
                HStack(spacing: 10) {
                    Image(systemName: audioController.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 30))
                    Text(audioController.isPlaying ? "Pause demo" : "Listen to \(ingredient.instrument)")
                        .font(.system(size: 18, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 28)
                .padding(.vertical, 14)
                .background(
                    LinearGradient(colors: [ingredient.color, ingredient.accentColor], startPoint: .leading, endPoint: .trailing)
                )
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            }
        }
        .padding(28)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 48, style: .continuous))
    }
    
    private var instrumentSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Instrument focus")
                .font(.cursive(.bold, size: 32))
            HStack(spacing: 18) {
                Image("Instruments/\(ingredient.instrumentImageAssetName)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 170, height: 170)
                    .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                    .shadow(color: Color.black.opacity(0.12), radius: 10, x: 0, y: 8)
                Text(scene.instrumentInsight)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black.opacity(0.75))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(28)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 48, style: .continuous))
    }
    
    private var pairingSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("How to use")
                .font(.cursive(.bold, size: 32))
            ForEach(scene.dialogues.filter { $0.speaker == "Narrator" }) { dialogue in
                Text(dialogue.text)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black.opacity(0.75))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(28)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 48, style: .continuous))
    }
    
    private var actionButtons: some View {
        VStack(spacing: 16) {
            if !isNext {
                Text("Unlock earlier stages before \(ingredient.name).")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black.opacity(0.6))
                    .padding()
                    .background(Color.white.opacity(0.9), in: RoundedRectangle(cornerRadius: 32, style: .continuous))
            }
            Button(action: {
                if isNext { onUnlock() }
            }) {
                Text(isNext ? "Unlock Ingredient" : "Locked")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 60)
                    .padding(.vertical, 16)
                    .background(isNext ? Color.black : Color.gray, in: RoundedRectangle(cornerRadius: 40, style: .continuous))
            }
            .disabled(!isNext)
            Button(action: onClose) {
                Text("Back to kitchen")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.black)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 14)
                    .background(Color.white.opacity(0.9), in: RoundedRectangle(cornerRadius: 40, style: .continuous))
            }
        }
    }
    
    private func toggleDemo() {
        if audioController.isPlaying {
            audioController.pause()
        } else {
            audioController.prepareTracks(for: [ingredient], variant: .demo)
            audioController.play()
        }
    }
}

#Preview {
    IngredientUnlockView(ingredient: Ingredient.palette.first!, isNext: true, onUnlock: {}, onClose: {})
}
