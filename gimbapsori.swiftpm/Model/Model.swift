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
}

extension Ingredient {
    static var palette: [Ingredient] {
        [
            Ingredient(
                id: "danmuji",
                name: "Danmuji",
                instrument: "Taepyeongso",
                description: "Brilliant Taepyeongso highs kick off the roll with a bright spark.",
                colorHex: "FFD447",
                accentHex: "F1A602",
                icon: "🥒"
            ),
            Ingredient(
                id: "sigeumchi",
                name: "Sigeumchi",
                instrument: "Daegeum",
                description: "Lush Daegeum phrases breathe verdant freshness across the roll.",
                colorHex: "5BB97F",
                accentHex: "1C7C47",
                icon: "🥬"
            ),
            Ingredient(
                id: "matsal",
                name: "Matsal",
                instrument: "Haegeum",
                description: "Clear Haegeum strings glide by with a silky, delicate texture.",
                colorHex: "FFA18F",
                accentHex: "F1505B",
                icon: "🦀"
            ),
            Ingredient(
                id: "ham",
                name: "Ham",
                instrument: "Piri",
                description: "Bold Piri melodies hold everything together like hearty ham.",
                colorHex: "F57E71",
                accentHex: "B04134",
                icon: "🥓"
            ),
            Ingredient(
                id: "ueong",
                name: "Ueong",
                instrument: "Ajaeng",
                description: "Deep, rustic Ajaeng resonance mirrors the sweet burdock roots.",
                colorHex: "8F633C",
                accentHex: "5B3C1F",
                icon: "🌰"
            ),
            Ingredient(
                id: "danggeun",
                name: "Danggeun",
                instrument: "Gayageum",
                description: "Crisp Gayageum plucks cut bright lines like vivid carrots.",
                colorHex: "FF9045",
                accentHex: "D1551C",
                icon: "🥕"
            ),
            Ingredient(
                id: "gyeran",
                name: "Gyeran Jidan",
                instrument: "Pyeonjong",
                description: "Graceful Pyeonjong chimes finish the roll with a soft shimmer.",
                colorHex: "FFE27A",
                accentHex: "FFC241",
                icon: "🥚"
            )
        ]
    }
}
