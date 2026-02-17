//
//  Model.swift
//  gimbapsori
//
//  Created by 나현흠 on 2/6/26.
//

import SwiftUI

struct Ingredient: Identifiable, Hashable {
    let id: String
    let name: String
    let instrument: String
    let description: String
    let colorHex: String
    let accentHex: String
    let icon: String
    
    var color: Color { Color(hex: colorHex) }
    var accentColor: Color { Color(hex: accentHex) }
}

extension Ingredient {
    static var palette: [Ingredient] {
        [
            Ingredient(
                id: "danmuji",
                name: "단무지",
                instrument: "태평소",
                description: "태평소의 화려한 고음으로 김밥의 시작을 여는 노란 포인트.",
                colorHex: "FFD447",
                accentHex: "F1A602",
                icon: "🥒"
            ),
            Ingredient(
                id: "sigeumchi",
                name: "시금치",
                instrument: "대금",
                description: "넉넉하게 깔리는 대금 선율처럼 파릇한 숨을 불어넣어요.",
                colorHex: "5BB97F",
                accentHex: "1C7C47",
                icon: "🥬"
            ),
            Ingredient(
                id: "matsal",
                name: "맛살",
                instrument: "해금",
                description: "해금의 맑은 현이 입안을 스치는 듯한 부드러운 질감.",
                colorHex: "FFA18F",
                accentHex: "F1505B",
                icon: "🦀"
            ),
            Ingredient(
                id: "ham",
                name: "햄",
                instrument: "피리",
                description: "피리의 선 굵은 멜로디가 둥근 햄처럼 든든하게 받쳐줍니다.",
                colorHex: "F57E71",
                accentHex: "B04134",
                icon: "🥓"
            ),
            Ingredient(
                id: "ueong",
                name: "우엉",
                instrument: "아쟁",
                description: "아쟁의 깊고 거친 울림이 달큰한 우엉에 닮았어요.",
                colorHex: "8F633C",
                accentHex: "5B3C1F",
                icon: "🌰"
            ),
            Ingredient(
                id: "danggeun",
                name: "당근",
                instrument: "가야금",
                description: "가야금의 명료한 현이 당근처럼 또렷하게 선을 그립니다.",
                colorHex: "FF9045",
                accentHex: "D1551C",
                icon: "🥕"
            ),
            Ingredient(
                id: "gyeran",
                name: "계란 지단",
                instrument: "편종",
                description: "편종의 단아한 울림을 고운 지단으로 얹어 마무리해요.",
                colorHex: "FFE27A",
                accentHex: "FFC241",
                icon: "🥚"
            )
        ]
    }
}
