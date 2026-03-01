//
//  MainView.swift
//  gimbapsori
//
//  Created by 나현흠 on 2/16/26.
//

import SwiftUI

struct MainView: View {
    let router: Router
    
    let GoToKitchenDescription = "Create your own gugak by mixing gimbap ingredients and layering traditional instrument sounds."
    let IngredientIntroDescription = "Learn how each ingredient connects to a traditional Korean instrument and its unique sound."
    let GimBapDescription = "Explore the gimbap combinations you’ve created and listen to your layered gugak compositions."
    
    var body: some View {
        ZStack {
            Image("GimPopSori_Background")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            
            Color.white.opacity(0.6)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 40) {
                HStack(spacing: 60) {
                    mainButton(title: "Go To Kitchen", image: "GoToKitchen", description: GoToKitchenDescription) {
                        router.push(.make)
                    }
                    mainButton(title: "Ingredient Intro", image: "IngredientIntro", description: IngredientIntroDescription) {
                        router.push(.ingredientIntroduce)
                    }
                    mainButton(title: "Gimbap List", image: "GimBapList", description: GimBapDescription) {
                        router.push(.description)
                    }
                }
            }
            .padding(.horizontal, 80)
            .padding(.vertical, 160)
        }
    }
    
    private func mainButton(title: String, image: String, description: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 80)
                    .fill(
                        Color(
                            red: 245/255,
                            green: 233/255,
                            blue: 209/255
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 80)
                            .stroke(Color.black, lineWidth: 3)
                    )
                VStack(spacing: 0) {
                    
                    Image(image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 280, height: 230)
                        .padding(.top, 30)
                    
                    Text(title)
                        .foregroundStyle(Color.black)
                        .font(.cursive(.bold, size: 70))
                        .padding(.top, 20)
                    
                    VStack {
                        Color.gray
                            .frame(height: 1)
                    }
                    .padding(.horizontal, 20)
                    
                    Text(description)
                        .foregroundStyle(Color.gray)
                        .font(.system(size: 24, weight: .regular))
                        .multilineTextAlignment(.center)
                        .padding(.top, 50)
                        .padding(.horizontal, 20)
                    
                    Spacer()
                }
            }
        }
        .frame(width: 350, height: 600)
    }
}

#Preview {
    MainView(router: Router())
}
