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
            return "The taepyeongso is a traditional Korean double-reed wind instrument, similar to a powerful oboe, known for its bright, sharp, and penetrating tone. Historically used in outdoor performances and ceremonies, it projects strongly enough to rise above drums and large crowds. In an ensemble, it often leads or highlights important musical moments, acting as a bold voice that immediately captures attention and adds dramatic color to the music."
        case "Daegeum":
            return "The daegeum is a traditional Korean bamboo flute known for its warm, airy sound and subtle buzzing texture created by a special membrane. Its tone can feel both gentle and expansive, like wind moving through open space. In an ensemble, the daegeum often carries long melodic lines or expressive phrases, adding emotional depth and a sense of breathing space within the music."
        case "Haegeum":
            return "The haegeum is a traditional Korean two-string bowed instrument played upright. Its sound is clear, slightly nasal, and highly expressive, capable of sliding smoothly between notes. In an ensemble, the haegeum often carries emotional melodies or expressive lines, adding human-like nuance and dramatic color to the music."
        case "Piri":
            return "The piri is a traditional Korean wooden double-reed instrument with a warm yet penetrating tone. Its sound is fuller and rounder than that of the taepyeongso, making it well suited for melodic lines in the middle register. In an ensemble, the piri often acts as a core melodic voice, grounding and connecting different musical layers."
        case "Ajaeng":
            return "The ajaeng is a traditional Korean bowed zither known for its deep and rough-textured tone. Played with a wooden bow, it produces a resonant and earthy sound that feels powerful and grounded. In ensemble music, the ajaeng supports the lower register, adding gravity and structural strength to the overall harmony."
        case "Gayageum":
            return "The gayageum is a traditional Korean plucked zither with multiple strings stretched across a wooden body. Its tone is bright, clear, and capable of delicate ornamentation. In an ensemble, the gayageum adds rhythmic detail and melodic decoration, bringing lightness and agility to the music."
        case "Geomungo":
            return "The geomungo is a traditional Korean plucked zither with a deep and resonant tone. Played with a bamboo stick, it produces strong, rhythmic bass sounds that feel grounded and steady. In ensemble music, the geomungo often provides structural support, shaping the harmonic foundation and giving the music a sense of stability and depth."
        default:
            return "Let this instrument guide the emotion of the roll." 
        }
    }
}
