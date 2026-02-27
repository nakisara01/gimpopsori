//
//  IngredientStoryView.swift
//  gimbapsori
//
//  Created by OpenAI Assistant on 2/20/26.
//

import SwiftUI

struct IngredientStoryView: View {
    let router: Router
    let progress: IngredientStoryProgress
    @StateObject private var audioController = GimbapAudioController()
    @State private var currentIndex: Int
    
    private let scenes = IngredientStoryScene.allScenes
    
    init(router: Router, progress: IngredientStoryProgress) {
        self.router = router
        self.progress = progress
        _currentIndex = State(initialValue: progress.index)
    }
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: "F9F5EF"), Color.white], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            Image("GimPopSori_Background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .opacity(0.1)
            
            ScrollView {
                VStack(spacing: 28) {
                    header
                    progressTimeline
                    currentSection
                    controlBar
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 24)
            }
        }
        .onDisappear {
            audioController.stop()
        }
    }
    
    private var currentScene: IngredientStoryScene {
        scenes[currentIndex]
    }
    
    private var header: some View {
        VStack(spacing: 8) {
            Text("Story Mode")
                .font(.cursive(.bold, size: 58))
            Text("Travel across every ingredient, study the instrument, and preview its tone before unlocking the next layer.")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.black.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
        }
    }
    
    private var progressTimeline: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(Array(scenes.enumerated()), id: \.element.id) { index, scene in
                    Circle()
                        .strokeBorder(index <= currentIndex ? Color.black : Color.black.opacity(0.2), lineWidth: 3)
                        .background(Circle().fill(index <= currentIndex ? Color.black : Color.clear))
                        .frame(width: 28, height: 28)
                        .overlay(Text("\(index + 1)").font(.system(size: 12, weight: .bold)).foregroundColor(index <= currentIndex ? .white : .black))
                }
            }
        }
        .padding(.vertical, 6)
    }
    
    private var currentSection: some View {
        VStack(spacing: 24) {
            ingredientHeroCard
            instrumentInsightCard
            pairingTipsCard
        }
    }
    
    private var ingredientHeroCard: some View {
        VStack(spacing: 18) {
            HStack(spacing: 20) {
                Image(currentScene.ingredient.imageAssetName ?? "")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 160, height: 160)
                    .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                    .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 8)
                VStack(alignment: .leading, spacing: 10) {
                    Text(currentScene.ingredient.name)
                        .font(.cursive(.bold, size: 42))
                    Text(currentScene.ingredient.description)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black.opacity(0.75))
                }
            }
            Button(action: playDemo) {
                HStack(spacing: 10) {
                    Image(systemName: audioController.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 30))
                    Text(audioController.isPlaying ? "Pause demo" : "Hear \(currentScene.ingredient.instrument)")
                        .font(.system(size: 18, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 14)
                .background(
                    LinearGradient(colors: [currentScene.ingredient.color, currentScene.ingredient.accentColor], startPoint: .leading, endPoint: .trailing)
                )
                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            }
        }
        .padding(26)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 48, style: .continuous))
    }
    
    private var instrumentInsightCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Instrument focus")
                .font(.cursive(.bold, size: 32))
            HStack(alignment: .center, spacing: 22) {
                Image("Instruments/\(currentScene.ingredient.instrumentImageAssetName)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 160, height: 160)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                VStack(alignment: .leading, spacing: 8) {
                    Text(currentScene.instrumentInsight)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black.opacity(0.75))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(26)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 48, style: .continuous))
    }
    
    private var pairingTipsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Pairing notes")
                .font(.cursive(.bold, size: 32))
            VStack(alignment: .leading, spacing: 12) {
                ForEach(currentScene.dialogues.filter { $0.speaker == "Narrator" }, id: \.id) { dialogue in
                    Text(dialogue.text)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black.opacity(0.75))
                }
            }
        }
        .padding(26)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 48, style: .continuous))
    }
    
    private var controlBar: some View {
        HStack(spacing: 20) {
            Button(action: goBack) {
                Label("Back", systemImage: "arrow.left")
                    .font(.system(size: 18, weight: .semibold))
                    .padding(.horizontal, 24)
                    .padding(.vertical, 14)
                    .background(Color.white.opacity(0.9), in: RoundedRectangle(cornerRadius: 30, style: .continuous))
            }
            .disabled(currentIndex == 0)
            Spacer()
            Button(action: advance) {
                Text(currentIndex == scenes.count - 1 ? "Finish" : "Unlock Next")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(Color.black, in: RoundedRectangle(cornerRadius: 40, style: .continuous))
            }
        }
    }
    
    private func playDemo() {
        if audioController.isPlaying {
            audioController.pause()
        } else {
            audioController.prepareTracks(for: [currentScene.ingredient], variant: .demo)
            audioController.play()
        }
    }
    
    private func goBack() {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
    }
    
    private func advance() {
        audioController.stop()
        if currentIndex < scenes.count - 1 {
            currentIndex += 1
        } else {
            router.push(.make)
        }
    }
}

#Preview {
    IngredientStoryView(router: Router(), progress: IngredientStoryProgress())
}
