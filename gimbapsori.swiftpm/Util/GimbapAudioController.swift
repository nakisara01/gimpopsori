//
//  GimbapAudioController.swift
//  gimbapsori
//
//  Created by OpenAI Assistant on 2/20/26.
//

import AVFoundation
import Foundation

@MainActor
final class GimbapAudioController: ObservableObject {
    @Published private(set) var isPrepared: Bool = false
    @Published private(set) var isPlaying: Bool = false
    @Published private(set) var activeTrackNames: [String] = []
    
    private var players: [AVAudioPlayer] = []
    
    func prepareTracks(for ingredients: [Ingredient]) {
        stop()
        let baseTracks = ["Gim", "Bap"]
        let ingredientTracks = ingredients.map { trackName(for: $0) }
        let allTracks = baseTracks + ingredientTracks
        var preparedPlayers: [AVAudioPlayer] = []
        var preparedNames: [String] = []
        for name in allTracks {
            guard let player = makePlayer(for: name) else { continue }
            player.numberOfLoops = -1
            player.volume = name == "Bap" ? 0.5 : 0.8
            preparedPlayers.append(player)
            preparedNames.append(name)
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
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            return nil
        }
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            return player
        } catch {
            print("Failed to load audio track \(name): \(error)")
            return nil
        }
    }
    
    private func trackName(for ingredient: Ingredient) -> String {
        let cleaned = ingredient.name.replacingOccurrences(of: " ", with: "")
        return cleaned
    }
}
