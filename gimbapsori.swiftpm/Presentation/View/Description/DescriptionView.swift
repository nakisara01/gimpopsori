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
                .accessibilityHidden(true)
            
            Color.white.opacity(0.6)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    Text("Gimbap Sori Storage")
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
                    HistoryCardView(gimbap: gimbap)
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
    
}

private struct HistoryCardView: View {
    let gimbap: CompletedGimbap
    @StateObject private var audioController = GimbapAudioController()
    @State private var playbackProgress: Double = 0
    @State private var isScrubbing: Bool = false
    @State private var isExporting: Bool = false
    @State private var shareItem: ShareItem?
    @State private var exportErrorMessage: String?
    private let exporter = GimbapAudioExporter()
    private let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
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
            HStack(alignment: .center, spacing: 28) {
                boardPreview
                    .frame(width: 240, height: 200)
                VStack(alignment: .leading, spacing: 16) {
                    instrumentStrip
                    playbackControls
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(20)
        .background(Color.white.opacity(0.85), in: RoundedRectangle(cornerRadius: 32, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 32)
                .stroke(Color.black.opacity(0.08), lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text("\(gimbap.name), saved on \(gimbap.createdAt.formatted(date: .abbreviated, time: .shortened)), \(gimbap.ingredients.count) Ingredient"))
        .onReceive(timer) { _ in updateProgress() }
        .sheet(item: $shareItem) { item in
            ShareSheet(items: [item.url])
        }
        .alert("Export Failed", isPresented: Binding(get: { exportErrorMessage != nil }, set: { _ in exportErrorMessage = nil })) {
            Button("Accept") {
                exportErrorMessage = nil
            }
        } message: {
            Text(exportErrorMessage ?? "Unidentified Error")
        }
    }

    private var boardPreview: some View {
        ZStack {
            Image("GimBapBase")
                .resizable()
                .scaledToFit()
                .shadow(color: Color.black.opacity(0.18), radius: 14, x: 0, y: 10)
                .accessibilityHidden(true)
            if gimbap.ingredients.isEmpty {
                Text("No layers")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.black.opacity(0.5))
            } else {
                GeometryReader { proxy in
                    VStack(spacing: -60) {
                        ForEach(gimbap.ingredients) { ingredient in
                            boardLayer(for: ingredient)
                        }
                    }
                    .padding(.horizontal, 54)
                    .padding(.vertical, 28)
                    .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                }
                .allowsHitTesting(false)
            }
        }
        .clipped()
        .accessibilityHidden(true)
    }

    private func boardLayer(for ingredient: Ingredient) -> some View {
        Group {
            if let asset = ingredient.imageAssetName {
                Image(asset)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 90 * ingredient.boardLayerScale)
                    .frame(maxWidth: .infinity)
            } else {
                HStack(spacing: 10) {
                    Text(ingredient.icon)
                    VStack(alignment: .leading, spacing: -2) {
                        Text(ingredient.name)
                            .font(.system(size: 18, weight: .semibold))
                        Text(ingredient.instrument)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.black.opacity(0.7))
                    }
                    Spacer()
                }
                .padding(.horizontal, 18)
                .frame(height: 56 * ingredient.boardLayerScale)
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(
                        colors: [ingredient.color.opacity(0.9), ingredient.accentColor.opacity(0.85)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.white.opacity(0.4), lineWidth: 1)
                )
            }
        }
    }

    private var instrumentStrip: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Instruments used")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.black.opacity(0.7))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(gimbap.ingredients) { ingredient in
                        VStack(spacing: 6) {
                            if let instrumentAsset = ingredient.instrumentImageAssetName {
                                Image(instrumentAsset)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 72, height: 72)
                                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                    .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 4)
                            } else {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.black.opacity(0.05))
                                    .frame(width: 72, height: 72)
                            }
                            Text(ingredient.instrument)
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .frame(width: 82)
                    }
                }
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text("Instrument used: \(gimbap.ingredients.map { $0.instrument }.joined(separator: ", "))"))
    }

    private var playbackControls: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Replay this roll")
                .font(.system(size: 16, weight: .semibold))
            HStack(spacing: 12) {
                Button(action: togglePlayback) {
                    Image(systemName: audioController.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.black)
                }
                .accessibilityLabel(Text(audioController.isPlaying ? "play stop" : "play"))
                .accessibilityHint(Text("Let's listen to the gimbap mix again."))
                Slider(
                    value: Binding(
                        get: { playbackProgress },
                        set: { newValue in
                            playbackProgress = newValue
                            if isScrubbing {
                                audioController.seek(to: newValue)
                            }
                        }
                    ),
                    in: 0...1,
                    onEditingChanged: { editing in
                        isScrubbing = editing
                        if !editing {
                            audioController.seek(to: playbackProgress)
                        }
                    }
                )
                .accessibilityLabel(Text("PlayHead"))
            }
            Button(action: exportMix) {
                HStack(spacing: 8) {
                    Image(systemName: "square.and.arrow.up")
                    Text(isExporting ? "Exporting..." : "Export audio")
                        .font(.system(size: 15, weight: .semibold))
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 16)
                .background(Color.white.opacity(0.9), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            }
            .disabled(isExporting || gimbap.ingredients.isEmpty)
            .opacity((isExporting || gimbap.ingredients.isEmpty) ? 0.4 : 1)
            if isExporting {
                HStack(spacing: 6) {
                    ProgressView()
                        .scaleEffect(0.8)
                    Text("You can play the sound for a short time while you're playing it.")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.black.opacity(0.7))
                }
            }
        }
    }

    private func togglePlayback() {
        if audioController.isPlaying {
            audioController.pause()
        } else {
            audioController.prepareTracks(for: gimbap.ingredients)
            audioController.play()
            playbackProgress = 0
        }
    }

    private func updateProgress() {
        guard audioController.isPlaying, !isScrubbing else { return }
        playbackProgress = audioController.normalizedProgress
    }

    private func exportMix() {
        guard !isExporting else { return }
        isExporting = true
        exporter.exportMix(for: gimbap.ingredients, fileName: gimbap.name) { result in
            isExporting = false
            switch result {
            case .success(let url):
                shareItem = ShareItem(url: url)
            case .failure(let error):
                exportErrorMessage = error.localizedDescription
            }
        }
    }
}

#Preview {
    DescriptionView(router: Router())
}
