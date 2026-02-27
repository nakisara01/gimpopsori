//
//  IngredientUnlockStorage.swift
//  gimbapsori
//
//  Created by OpenAI Assistant on 2/21/26.
//

import Foundation

final class IngredientUnlockStorage {
    @MainActor static let shared = IngredientUnlockStorage()
    private let fileURL: URL
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private init() {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            ?? FileManager.default.temporaryDirectory
        fileURL = directory.appendingPathComponent("ingredient_unlocks.json")
    }
    
    func load() -> IngredientUnlockProgress {
        guard let data = try? Data(contentsOf: fileURL) else {
            return IngredientUnlockProgress()
        }
        return (try? decoder.decode(IngredientUnlockProgress.self, from: data)) ?? IngredientUnlockProgress()
    }
    
    func save(_ progress: IngredientUnlockProgress) {
        do {
            let data = try encoder.encode(progress)
            try data.write(to: fileURL, options: [.atomic])
        } catch {
            print("Failed to save ingredient unlock progress: \(error)")
        }
    }
}
