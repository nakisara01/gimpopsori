//
//  Model.swift
//  gimbapsori
//
//  Created by 나현흠 on 2/6/26.
//

import SwiftUI

struct Ingredient: Identifiable, Hashable, Codable {
    let id: String
    let name: String
    let instrument: String
    let description: String
    let explanation: String
    let colorHex: String
    let accentHex: String
    let icon: String
    
    var color: Color { Color(hex: colorHex) }
    var accentColor: Color { Color(hex: accentHex) }
    
    var imageAssetName: String? {
        switch id {
        case "danmuji": return "Danmuji"
        case "sigeumchi": return "Spanich"
        case "matsal": return "Matsal"
        case "ham": return "Ham"
        case "ueong": return "WooEong"
        case "danggeun": return "Carrot"
        case "gyeran": return "EggJidan"
        default: return nil
        }
    }
    
    var instrumentImageAssetName: String? {
        switch instrument {
        case "Taepyeongso": return "Taepyeongso"
        case "Daegeum": return "Daegeum"
        case "Haegeum": return "Haegeum"
        case "Piri": return "Piri"
        case "Ajaeng": return "Ajaeng"
        case "Gayageum": return "Gayageum"
        case "Geomungo": return "Geomungo"
        default: return "InstrumentPlaceholder"
        }
    }
    
    var boardLayerScale: CGFloat {
        switch id {
        case "matsal":
            return 0.6
        case "gyeran":
            return 0.78
        default:
            return 1.0
        }
    }
}

extension Ingredient {
    static var palette: [Ingredient] {
        [
            Ingredient(
                id: "danmuji",
                name: "Danmuji",
                instrument: "Taepyeongso",
                description: "Brilliant Taepyeongso highs kick off the roll with a bright spark.",
                explanation: "Danmuji is a bright yellow pickled radish commonly placed inside Korean kimbap, a seaweed rice roll layered with vegetables and other fillings. It tastes lightly sweet and tangy, with a crisp crunch that refreshes your palate between bites and balances softer ingredients like rice and egg. Danmuji pairs naturally with the taepyeongso because both are bold and attention-grabbing—just as the radish’s sharp flavor cuts through the roll, the taepyeongso’s piercing sound cuts through an ensemble, adding brightness and energy to the whole composition.",
                colorHex: "FFD447",
                accentHex: "F1A602",
                icon: "🥒"
            ),
            Ingredient(
                id: "sigeumchi",
                name: "Spanich",
                instrument: "Daegeum",
                description: "Lush Daegeum phrases breathe verdant freshness across the roll.",
                explanation: "Spinach in kimbap is lightly seasoned and blanched, offering a soft texture and a fresh, earthy flavor that balances brighter or richer ingredients. Its deep green color brings a natural calmness to the roll, adding depth without overpowering the other layers. Spinach pairs with the daegeum, a large Korean bamboo flute, because both provide warmth and flow—just as spinach smooths the flavor of the roll, the daegeum’s airy, breath-filled tone gently connects musical phrases and carries the melody with quiet elegance.",
                colorHex: "5BB97F",
                accentHex: "1C7C47",
                icon: "🥬"
            ),
            Ingredient(
                id: "matsal",
                name: "Crab Stick",
                instrument: "Haegeum",
                description: "Clear Haegeum strings glide by with a silky, delicate texture.",
                explanation: "Crab Stick in kimbap is tender, slightly sweet, and visually bright with its red-and-white strands. It adds a soft texture that contrasts with crisp vegetables and gives the roll a gentle seafood note. Imitation crab pairs with the haegeum because both feel expressive and flexible—just as the crab blends smoothly among the ingredients, the haegeum glides between notes with a voice-like tone, adding emotion and fluid movement to the music.",
                colorHex: "FFA18F",
                accentHex: "F1505B",
                icon: "🦀"
            ),
            Ingredient(
                id: "ham",
                name: "Ham",
                instrument: "Piri",
                description: "Bold Piri melodies hold everything together like hearty ham.",
                explanation: "Ham in kimbap brings a savory and slightly salty richness that makes the roll feel hearty and balanced. Its firm texture and familiar flavor help anchor the lighter vegetables around it. Ham pairs with the piri because both have a strong and centered presence—just as ham stabilizes the taste of the roll, the piri provides a focused, resonant tone that supports the middle range of the ensemble.",
                colorHex: "F57E71",
                accentHex: "B04134",
                icon: "🥩"
            ),
            Ingredient(
                id: "ueong",
                name: "Burdock",
                instrument: "Ajaeng",
                description: "Deep, rustic Ajaeng resonance mirrors the sweet burdock roots.",
                explanation: "Burdock root in kimbap is simmered to bring out its earthy sweetness and chewy texture. It adds depth and a grounded character to the roll, giving it a slightly rustic flavor. Burdock pairs with the ajaeng because both provide weight and foundation—just as burdock strengthens the base flavor, the ajaeng produces deep, resonant tones that reinforce the lower layer of the ensemble.",
                colorHex: "8F633C",
                accentHex: "5B3C1F",
                icon: "🌰"
            ),
            Ingredient(
                id: "danggeun",
                name: "Carrot",
                instrument: "Gayageum",
                description: "Crisp Gayageum plucks cut bright lines like vivid carrots.",
                explanation: "Carrot in kimbap is lightly sautéed to keep its natural sweetness and gentle crunch. Its bright orange color adds energy and visual liveliness to each slice. Carrot pairs with the gayageum because both feel light and sparkling—just as carrot brightens the roll, the gayageum’s crisp, plucked notes add rhythmic sparkle and playful detail to the composition.",
                colorHex: "FF9045",
                accentHex: "D1551C",
                icon: "🥕"
            ),
            Ingredient(
                id: "gyeran",
                name: "Egg Ganish",
                instrument: "Geomungo",
                description: "Graceful Pyeonjong chimes finish the roll with a soft shimmer.",
                explanation: "Egg Ganish in kimbap is thinly sliced omelet that offers a soft texture and mild, comforting flavor. It gently surrounds and connects the other ingredients without overpowering them. Egg ganish pairs with the geomungo because both provide quiet structure—just as the egg binds flavors together, the geomungo supports the harmony with steady, resonant bass tones.",
                colorHex: "FFE27A",
                accentHex: "FFC241",
                icon: "🥚"
            )
        ]
    }
}
