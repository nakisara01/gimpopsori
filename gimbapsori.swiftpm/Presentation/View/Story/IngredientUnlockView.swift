//
//  IngredientUnlockView.swift
//  gimbapsori
//
//  Created by OpenAI Assistant on 2/21/26.
//

import SwiftUI
import AVFoundation

struct IngredientUnlockView: View {
    let ingredient: Ingredient
    let isNext: Bool
    let isUnlocked: Bool
    let onUnlock: () -> Void
    let onClose: () -> Void
    @State private var samplePlayer: AVAudioPlayer?
    @State private var sampleProgress: Double = 0
    @State private var sampleDuration: Double = 0
    @State private var isScrubbingSample: Bool = false
    @State private var sampleWasPlayingBeforeScrub: Bool = false
    @State private var isSampleLoaded: Bool = false
    @State private var hasSamplePlayed: Bool = false
    private let scene: IngredientStoryScene
    
    init(ingredient: Ingredient, isNext: Bool, isUnlocked: Bool, onUnlock: @escaping () -> Void, onClose: @escaping () -> Void) {
        self.ingredient = ingredient
        self.isNext = isNext
        self.isUnlocked = isUnlocked
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
                .accessibilityHidden(true)
            
            ScrollView {
                VStack(spacing: 26) {
                    header
                    heroSection
                    instrumentSection
                    actionButtons
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 30)
            }
        }
        .onAppear {
            prepareSamplePlayer()
        }
        .onDisappear {
            samplePlayer?.stop()
        }
        .onReceive(Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()) { _ in
            guard let player = samplePlayer, sampleDuration > 0, !isScrubbingSample else { return }
            if player.isPlaying {
                sampleProgress = player.currentTime / sampleDuration
            }
            if player.currentTime >= player.duration {
                player.stop()
                sampleProgress = 1
            }
        }
    }
    
    private var header: some View {
        VStack(spacing: 8) {
            Text("Unlock \(ingredient.name)")
                .font(.cursive(.bold, size: 72))
        }
        .frame(maxWidth: .infinity)
    }
    
    private var heroSection: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Ingredients")
                .font(.cursive(.bold, size: 32))
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
                    Text(ingredient.explanation)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black.opacity(0.75))
                }
            }
            .padding(.top, -20)
        }
        .padding(28)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 48, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 48)
                .stroke(Color.black.opacity(0.05), lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text("Ingredient \(ingredient.name). \(ingredient.description)"))
        .accessibilityHint(Text("Review ingredient story before unlocking."))
    }
    
    private var instrumentSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Instrument focus")
                .font(.cursive(.bold, size: 32))
            HStack(spacing: 18) {
                Image(ingredient.instrumentImageAssetName ?? "")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 170, height: 170)
                    .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                    .shadow(color: Color.black.opacity(0.12), radius: 10, x: 0, y: 8)
                VStack(alignment: .leading, spacing: 10) {
                    Text(ingredient.instrument)
                        .font(.cursive(.bold, size: 42))
                    Text(scene.instrumentInsight)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black.opacity(0.75))
                }
            }
            .padding(.top, -20)
            
            sampleControl
        }
        .padding(28)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 48, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 48)
                .stroke(Color.black.opacity(0.05), lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text("Instrument \(ingredient.instrument). \(scene.instrumentInsight)"))
        .accessibilityHint(Text("Use the sample sound controls to listen."))
    }
    
    private var actionButtons: some View {
        VStack(spacing: 18) {
            if isUnlocked {
                Text("\(ingredient.name) is already Unlocked.")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black.opacity(0.6))
                    .padding()
                    .background(Color.white.opacity(0.9), in: RoundedRectangle(cornerRadius: 32, style: .continuous))
            } else if !isNext {
                Text("Unlock earlier stages before \(ingredient.name).")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black.opacity(0.6))
                    .padding()
                    .background(Color.white.opacity(0.9), in: RoundedRectangle(cornerRadius: 32, style: .continuous))
            }
            HStack(spacing: 20) {
                Button(action: {
                    if isNext && hasSamplePlayed { onUnlock() }
                }) {
                    Text(primaryButtonTitle)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background((isNext && hasSamplePlayed) ? Color.black : Color.gray, in: RoundedRectangle(cornerRadius: 32, style: .continuous))
                }
                .disabled(!isNext || !hasSamplePlayed)
                .accessibilityHint(Text(isNext ? "Listen to the sample before unlocking." : "Unlock previous ingredients first."))
                Button(action: onClose) {
                    Text("Back to kitchen")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.white.opacity(0.9), in: RoundedRectangle(cornerRadius: 32, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 32)
                                .stroke(Color.black.opacity(0.1), lineWidth: 1)
                        )
                }
                .accessibilityHint(Text("Return to the kitchen."))
            }
        }
    }

    private var primaryButtonTitle: String {
        if isUnlocked {
            return "Already Unlocked"
        } else if !isNext {
            return "Locked"
        } else if hasSamplePlayed {
            return "Unlock Ingredient"
        } else {
            return "Listen first"
        }
    }
    
    private var sampleControl: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Sample sound")
                    .font(.system(size: 16, weight: .semibold))
                Spacer()
                Text(sampleTimeLabel)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.black.opacity(0.6))
            }
            HStack(spacing: 14) {
                Button(action: toggleSamplePlayback) {
                    Image(systemName: (samplePlayer?.isPlaying ?? false) ? "pause.fill" : "play.fill")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 46, height: 46)
                        .background(Color.black, in: Circle())
                }
                .accessibilityLabel(Text((samplePlayer?.isPlaying ?? false) ? "Pause sample" : "Play sample"))
                .accessibilityHint(Text("Preview the instrument sound."))
                Slider(
                    value: $sampleProgress,
                    in: 0...1,
                    onEditingChanged: { editing in
                        isScrubbingSample = editing
                        if editing {
                            sampleWasPlayingBeforeScrub = samplePlayer?.isPlaying ?? false
                            samplePlayer?.pause()
                        } else {
                            seekSample(to: sampleProgress)
                            if sampleWasPlayingBeforeScrub {
                                samplePlayer?.play()
                            }
                        }
                    }
                )
                .accessibilityLabel(Text("Sample progress"))
                .disabled(!isSampleLoaded)
            }
        }
        .padding(.top, 10)
    }
    
    private var sampleTimeLabel: String {
        guard isSampleLoaded else { return "00:00 / 00:00" }
        let current = sampleProgress * sampleDuration
        return "\(formatTime(current)) / \(formatTime(sampleDuration))"
    }
    
    private func toggleSamplePlayback() {
        if samplePlayer == nil {
            prepareSamplePlayer()
        }
        guard let player = samplePlayer else { return }
        if player.isPlaying {
            player.pause()
        } else {
            if player.currentTime >= player.duration {
                player.currentTime = 0
                sampleProgress = 0
            }
            player.play()
            hasSamplePlayed = true
        }
    }
    
    private func prepareSamplePlayer() {
        samplePlayer?.stop()
        samplePlayer = nil
        guard let url = sampleAudioURL() else { return }
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            samplePlayer = player
            sampleDuration = player.duration
            sampleProgress = 0
            isSampleLoaded = true
        } catch {
            print("Failed to load sample audio: \(error)")
            isSampleLoaded = false
        }
    }
    
    private func seekSample(to progress: Double) {
        guard let player = samplePlayer, sampleDuration > 0 else { return }
        player.currentTime = min(max(progress, 0), 1) * sampleDuration
    }
    
    private func sampleAudioURL() -> URL? {
        guard let resource = sampleResourceName() else { return nil }
        let extensions = ["wav", "mp3", "m4a"]
        for ext in extensions {
            if let url = Bundle.main.url(forResource: resource, withExtension: ext) {
                return url
            }
        }
        return nil
    }
    
    private func sampleResourceName() -> String? {
        let baseName = ingredient.instrument
        let sampleCandidate = "\(baseName)_Sample"
        let extensions = ["wav", "mp3", "m4a"]
        for ext in extensions {
            if Bundle.main.url(forResource: sampleCandidate, withExtension: ext) != nil {
                return sampleCandidate
            }
        }
        for ext in extensions {
            if Bundle.main.url(forResource: baseName, withExtension: ext) != nil {
                return baseName
            }
        }
        return nil
    }
    
    private func formatTime(_ seconds: Double) -> String {
        guard seconds.isFinite else { return "00:00" }
        let totalSeconds = Int(seconds.rounded())
        let minutes = totalSeconds / 60
        let remainder = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, remainder)
    }
}

#Preview {
    IngredientUnlockView(ingredient: Ingredient.palette.first!, isNext: true, isUnlocked: false, onUnlock: {}, onClose: {})
}
