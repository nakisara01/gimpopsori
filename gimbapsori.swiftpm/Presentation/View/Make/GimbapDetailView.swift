//
//  GimbapDetailView.swift
//  gimbapsori
//
//  Created by OpenAI Assistant on 2/20/26.
//

import SwiftUI

struct GimbapDetailView: View {
    let gimbap: CompletedGimbap
    let router: Router?
    let onClose: () -> Void
    let onNameChange: (String) -> Void
    @StateObject private var audioController = GimbapAudioController()
    @State private var rollProgress: CGFloat = 0
    @State private var gimbapName: String = ""
    @State private var savedName: String = ""
    private let storage = GimbapStorage.shared
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: "F8F5EE"), Color.white], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            Image("GimPopSori_Background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .opacity(0.12)
            
            ScrollView {
                VStack(spacing: 28) {
                    header
                    heroCard
                    ingredientsCard
                    audioCard
                    primaryButton
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 20)
            }
        }
        .onAppear {
            audioController.prepareTracks(for: gimbap.ingredients)
            if gimbapName.isEmpty {
                gimbapName = gimbap.name
                savedName = gimbap.name
            }
            animateRoll()
        }
        .onDisappear {
            audioController.stop()
        }
        .onChange(of: gimbapName) { newValue in
            persistName(newValue)
        }
    }
    
    private var header: some View {
        VStack(spacing: 6) {
            Text("Your gugak roll is ready")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.black.opacity(0.6))
            Text(gimbapName.isEmpty ? "Untitled Roll" : gimbapName)
                .font(.cursive(.bold, size: 56))
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var heroCard: some View {
        VStack(spacing: 24) {
            HStack(alignment: .center, spacing: 28) {
                boardPreview
                    .frame(width: 260, height: 220)
                VStack(alignment: .leading, spacing: 18) {
                    TextField("Enter a memorable name", text: $gimbapName)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color.white.opacity(0.92))
                        )
                        .font(.system(size: 20, weight: .semibold))
                    infoRow(title: "Created", value: gimbap.createdAt.formatted(date: .abbreviated, time: .shortened))
                        .padding(.leading, 12)
                    infoRow(title: "Layers", value: "\(gimbap.ingredients.count) instruments")
                        .padding(.leading, 12)
                }
                .padding(.leading, 12)
            }
        }
        .padding(28)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 48, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 48)
                .stroke(Color.black.opacity(0.08), lineWidth: 1)
        )
    }
    
    private var ingredientsCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Layers in this roll")
                .font(.cursive(.bold, size: 32))
            let columnCount = max(1, min(7, gimbap.ingredients.count))
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: columnCount), spacing: 16) {
                ForEach(gimbap.ingredients) { ingredient in
                    VStack(spacing: 10) {
                        Image(ingredient.instrumentImageAssetName ?? "")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        VStack(spacing: 2) {
                            Text(ingredient.instrument)
                                .font(.system(size: 16, weight: .semibold))
                            Text(ingredient.name)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.black.opacity(0.6))
                        }
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(Color(
                        red: 245/255,
                        green: 233/255,
                        blue: 209/255
                    ), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                }
            }
        }
        .padding(28)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 48, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 48)
                .stroke(Color.black.opacity(0.05), lineWidth: 1)
        )
    }
    
    private var audioCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Hear the ensemble")
                .font(.cursive(.bold, size: 32))
            Text("Gim + Bap bases blend with every instrument you chose.")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.black.opacity(0.65))
            Button(action: audioController.togglePlayback) {
                HStack(spacing: 12) {
                    Image(systemName: audioController.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 36, weight: .medium))
                    Text(audioController.isPlaying ? "Pause gugak mix" : "Play gugak mix")
                        .font(.system(size: 20, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 28)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    LinearGradient(colors: [Color(hex: "141414"), Color(hex: "383838")], startPoint: .leading, endPoint: .trailing)
                )
                .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                .opacity(audioController.isPrepared ? 1 : 0.4)
            }
            .disabled(!audioController.isPrepared)
        }
        .padding(28)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 48, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 48)
                .stroke(Color.black.opacity(0.05), lineWidth: 1)
        )
    }
    
    private func infoRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.black.opacity(0.6))
            Spacer()
            Text(value)
                .font(.system(size: 18, weight: .semibold))
        }
    }
    
    private var primaryButton: some View {
        Button(action: handleBackToMain) {
            Text("Back to Main")
                .font(.cursive(.bold, size: 30))
                .foregroundColor(.black)
                .padding(.horizontal, 60)
                .padding(.vertical, 18)
                .background(
                    RoundedRectangle(cornerRadius: 48)
                        .fill(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 48)
                                .stroke(Color.black, lineWidth: 3)
                        )
                )
        }
        .padding(.bottom, 24)
    }

    private func animateRoll() {
        rollProgress = 0
        withAnimation(.easeInOut(duration: 1.6)) {
            rollProgress = 1
        }
    }
    
    private func handleBackToMain() {
        onClose()
        router?.popToRoot()
        router?.push(.main)
    }

    private var boardPreview: some View {
        ZStack {
            Image("GimBapBase")
                .resizable()
                .scaledToFit()
                .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 16)
            if gimbap.ingredients.isEmpty {
                Text("No layers selected")
                    .font(.cursive(.medium, size: 24))
                    .foregroundColor(.black.opacity(0.5))
            } else {
                GeometryReader { proxy in
                    VStack(spacing: -90) {
                        ForEach(gimbap.ingredients) { ingredient in
                            boardLayer(for: ingredient)
                        }
                    }
                .padding(.horizontal, 42)
                .padding(.vertical, 28)
                    .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                }
                .allowsHitTesting(false)
            }
        }
        .frame(width: 320, height: 260)
        .clipped()
    }
    
    private func boardLayer(for ingredient: Ingredient) -> some View {
        Group {
            if let asset = ingredient.imageAssetName {
                let height = 110 * ingredient.boardLayerScale
                Image(asset)
                    .resizable()
                    .scaledToFit()
                    .frame(height: height)
                    .frame(maxWidth: .infinity)
            } else {
                HStack(spacing: 12) {
                    Text(ingredient.icon)
                    VStack(alignment: .leading, spacing: -2) {
                        Text(ingredient.name)
                            .font(.cursive(.bold, size: 24))
                        Text(ingredient.instrument)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.black.opacity(0.8))
                    }
                    Spacer()
                }
                .padding(.horizontal, 26)
                .frame(height: 68 * ingredient.boardLayerScale)
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [ingredient.color.opacity(0.95), ingredient.accentColor.opacity(0.85)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(Color.white.opacity(0.4), lineWidth: 1)
                )
            }
        }
    }
    
    private func persistName(_ name: String) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        guard trimmed != savedName else { return }
        storage.updateName(for: gimbap.id, to: trimmed)
        onNameChange(trimmed)
        savedName = trimmed
    }
}

#Preview {
    GimbapDetailView(gimbap: CompletedGimbap(ingredients: Ingredient.palette), router: Router(), onClose: {}, onNameChange: { _ in })
}
