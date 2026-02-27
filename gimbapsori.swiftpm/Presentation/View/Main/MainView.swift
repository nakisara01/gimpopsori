//
//  MainView.swift
//  gimbapsori
//
//  Created by 나현흠 on 2/16/26.
//

import SwiftUI

struct MainView: View {
    let router: Router
    
    var body: some View {
        ZStack {
            Image("GimPopSori_Background")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            
            Color.white.opacity(0.6)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 60) {
                HStack(spacing: 60) {
                    mainButton(title: "Go To Kitchen") {
                        router.push(.make)
                    }
                    mainButton(title: "Ingredient Intro") {
                        router.push(.ingredientIntroduce)
                    }
                    mainButton(title: "Gimbap List") {
                        router.push(.description)
                    }
                }
            }
            .padding(.horizontal, 80)
            .padding(.vertical, 160)
        }
    }
    
    private func mainButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 80)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 80)
                            .stroke(Color.black, lineWidth: 8)
                    )
                Text(title)
                    .foregroundStyle(Color.black)
                    .font(.cursive(.bold, size: 70))
                    .padding(.top, 20)
            }
        }
        .frame(width: 260, height: 320)
    }
}

#Preview {
    MainView(router: Router())
}
