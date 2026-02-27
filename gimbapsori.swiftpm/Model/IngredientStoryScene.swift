//
//  IngredientStoryScene.swift
//  gimbapsori
//
//  Created by OpenAI Assistant on 2/20/26.
//

import Foundation

struct IngredientStoryDialogue: Identifiable, Hashable {
    let id = UUID()
    let speaker: String
    let text: String
}

struct IngredientStoryScene: Identifiable, Hashable {
    let id = UUID()
    let ingredient: Ingredient
    let dialogues: [IngredientStoryDialogue]
    let instrumentInsight: String
    
    static var allScenes: [IngredientStoryScene] {
        let palette = Ingredient.palette
        return palette.enumerated().map { index, ingredient in
            IngredientStoryScene(
                ingredient: ingredient,
                dialogues: dialogues(for: ingredient, stage: index + 1, total: palette.count),
                instrumentInsight: instrumentFlavor(for: ingredient.instrument)
            )
        }
    }
    
    private static func dialogues(for ingredient: Ingredient, stage: Int, total: Int) -> [IngredientStoryDialogue] {
        let intro = "Stage \(stage)/\(total): We now unlock \(ingredient.name), guardian of the \(ingredient.instrument)."
        let mentor = ingredient.description
        let instrumentInsight = instrumentFlavor(for: ingredient.instrument)
        let tip = "Picture this layer riding on the Gim and Bap grooves. Try pairing \(ingredient.name) with two neighbors to build tension before the finale."
        return [
            IngredientStoryDialogue(speaker: "Chef", text: intro),
            IngredientStoryDialogue(speaker: ingredient.name, text: "I speak through the \(ingredient.instrument). When I'm laid across the rice, I paint colors that your ears can taste."),
            IngredientStoryDialogue(speaker: "Mentor", text: mentor + " " + instrumentInsight),
            IngredientStoryDialogue(speaker: "Narrator", text: tip)
        ]
    }
    
    private static func instrumentFlavor(for instrument: String) -> String {
        switch instrument {
        case "Taepyeongso":
            return "The Taepyeongso's piercing reed announces celebrations, so expect bright calls answered by the backing layers."
        case "Daegeum":
            return "The Daegeum breathes long bamboo phrases, weaving air between beats and keeping the roll open."
        case "Haegeum":
            return "The Haegeum's bowed strings slide between notes, bending pitch like a spoon through rice."
        case "Piri":
            return "Piri tones are woody and focused; they anchor the middle register so other voices can sit atop them."
        case "Ajaeng":
            return "Ajaeng scrapes produce gravelly resonance, giving the roll depth like toasted sesame."
        case "Gayageum":
            return "Gayageum plucks sparkle quickly, filling gaps with crisp chatter between heavier hits."
        case "Pyeonjong":
            return "Pyeonjong bells shimmer after every strike, showering brightness across the ensemble."
        default:
            return "Let this instrument guide the emotion of the roll." 
        }
    }
}
