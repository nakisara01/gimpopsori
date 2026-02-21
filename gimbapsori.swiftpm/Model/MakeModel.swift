//
//  MakeModel.swift
//  gimbapsori
//
//  Created by OpenAI Assistant on 2/18/26.
//

import Foundation

struct IngredientPlacement: Identifiable, Hashable {
    let id: UUID = .init()
    let ingredient: Ingredient
}

struct MakeModel {
    var layers: [IngredientPlacement] = []
    var selectedIngredient: Ingredient?
}

