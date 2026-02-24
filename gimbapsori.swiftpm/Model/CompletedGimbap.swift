//
//  CompletedGimbap.swift
//  gimbapsori
//
//  Created by OpenAI Assistant on 2/20/26.
//

import Foundation

struct CompletedGimbap: Identifiable, Codable, Hashable {
    let id: UUID
    let createdAt: Date
    var name: String
    let ingredients: [Ingredient]
    
    init(id: UUID = UUID(), createdAt: Date = Date(), name: String = "My Gugak Roll", ingredients: [Ingredient]) {
        self.id = id
        self.createdAt = createdAt
        self.name = name
        self.ingredients = ingredients
    }
}
