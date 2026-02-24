//
//  GimbapStorage.swift
//  gimbapsori
//
//  Created by OpenAI Assistant on 2/20/26.
//

import Foundation

final class GimbapStorage: @unchecked Sendable {
    static let shared = GimbapStorage()
    
    private let fileURL: URL
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    private init() {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            ?? FileManager.default.temporaryDirectory
        fileURL = directory.appendingPathComponent("completed_gimbaps.json")
        encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted]
        decoder = JSONDecoder()
    }
    
    func load() -> [CompletedGimbap] {
        guard let data = try? Data(contentsOf: fileURL) else { return [] }
        do {
            return try decoder.decode([CompletedGimbap].self, from: data)
        } catch {
            print("Failed to decode gimbap history: \(error)")
            return []
        }
    }
    
    func append(_ gimbap: CompletedGimbap) {
        var current = load()
        current.insert(gimbap, at: 0)
        save(current)
    }
    
    func updateName(for id: UUID, to newName: String) {
        let trimmed = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        var current = load()
        guard let index = current.firstIndex(where: { $0.id == id }) else { return }
        current[index].name = trimmed
        save(current)
    }
    
    private func save(_ gimbaps: [CompletedGimbap]) {
        do {
            let data = try encoder.encode(gimbaps)
            try data.write(to: fileURL, options: [.atomic])
        } catch {
            print("Failed to save gimbap history: \(error)")
        }
    }
}
