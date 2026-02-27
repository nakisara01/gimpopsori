//
//  GimbapAudioController.swift
//  gimbapsori
//
//  Created by OpenAI Assistant on 2/20/26.
//

import AVFoundation
import Foundation

@MainActor
final class GimbapAudioController: NSObject, ObservableObject {
    enum TrackVariant {
        case ensemble
        case demo
    }
    @Published private(set) var isPrepared: Bool = false
    @Published private(set) var isPlaying: Bool = false
    @Published private(set) var activeTrackNames: [String] = []
    
    private struct AudioTrack {
        let resourceName: String
        let displayName: String
        let volume: Float
    }
    
    private let baseTrack = AudioTrack(resourceName: "GimbapBase", displayName: "Gimbap Base", volume: 0.7)
    private let instrumentResourceMap: [String: String] = [
        "Taepyeongso": "Taepyeongso",
        "Daegeum": "Daegeum",
        "Haegeum": "Haegeum",
        "Piri": "Piri",
        "Ajaeng": "Ajeng",
        "Gayageum": "Gayageum",
        "Geomungo": "Geomungo"
    ]
    private let instrumentSampleResourceMap: [String: String] = [
        "Piri": "Piri_Sample"
    ]
    
    private var players: [AVAudioPlayer] = []
    
    func prepareTracks(for ingredients: [Ingredient], variant: TrackVariant = .ensemble) {
        stop()
        var tracks: [AudioTrack] = []
        if variant == .ensemble {
            tracks.append(baseTrack)
        }
        tracks.append(contentsOf: ingredientTracks(for: ingredients, variant: variant))
        guard !tracks.isEmpty else {
            isPrepared = false
            return
        }
        var preparedPlayers: [AVAudioPlayer] = []
        var preparedNames: [String] = []
        for track in tracks {
            guard let player = makePlayer(for: track.resourceName) else { continue }
            player.numberOfLoops = 0
            player.volume = track.volume
            player.delegate = self
            preparedPlayers.append(player)
            preparedNames.append(track.displayName)
        }
        players = preparedPlayers
        activeTrackNames = preparedNames
        isPrepared = !players.isEmpty
    }
    
    func togglePlayback() {
        guard isPrepared else { return }
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    func play() {
        guard isPrepared else { return }
        players.forEach { $0.currentTime = 0 }
        players.forEach { $0.play() }
        isPlaying = true
    }
    
    func pause() {
        players.forEach { $0.pause() }
        isPlaying = false
    }
    
    func stop() {
        players.forEach { $0.stop() }
        players.removeAll()
        activeTrackNames.removeAll()
        isPlaying = false
        isPrepared = false
    }
    
    private func makePlayer(for name: String) -> AVAudioPlayer? {
        let supportedExtensions = ["wav", "mp3", "m4a"]
        for ext in supportedExtensions {
            if let url = Bundle.main.url(forResource: name, withExtension: ext) {
                do {
                    let player = try AVAudioPlayer(contentsOf: url)
                    player.prepareToPlay()
                    return player
                } catch {
                    print("Failed to load audio track \(name).\(ext): \(error)")
                }
            }
        }
        print("Missing audio track resource for name: \(name)")
        return nil
    }
    
    private func ingredientTracks(for ingredients: [Ingredient], variant: TrackVariant) -> [AudioTrack] {
        var seen: Set<String> = []
        var tracks: [AudioTrack] = []
        for ingredient in ingredients {
            guard let track = track(for: ingredient, variant: variant) else { continue }
            if !seen.contains(track.resourceName) {
                seen.insert(track.resourceName)
                tracks.append(track)
            }
        }
        return tracks
    }
    
    private func track(for ingredient: Ingredient, variant: TrackVariant) -> AudioTrack? {
        let resourceName: String
        switch variant {
        case .ensemble:
            guard let resource = instrumentResourceMap[ingredient.instrument] else { return nil }
            resourceName = resource
        case .demo:
            if let sample = instrumentSampleResourceMap[ingredient.instrument] {
                resourceName = sample
            } else if let resource = instrumentResourceMap[ingredient.instrument] {
                resourceName = resource
            } else {
                return nil
            }
        }
        let displaySuffix = variant == .demo && instrumentSampleResourceMap[ingredient.instrument] != nil ? " (Demo)" : ""
        let volume: Float = variant == .demo ? 1.0 : 0.9
        return AudioTrack(resourceName: resourceName, displayName: ingredient.instrument + displaySuffix, volume: volume)
    }
}

extension GimbapAudioController: AVAudioPlayerDelegate {
    nonisolated func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        Task { @MainActor in
            if self.players.allSatisfy({ !$0.isPlaying }) {
                self.isPlaying = false
            }
        }
    }
}
