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
            
            HStack {
                Button(action: {
                    router.push(.make)
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 100)
                            .fill(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 100.0)
                                    .stroke(Color.black, lineWidth: 10)
                            )
                            
                        Text("Go To Kitchen")
                            .foregroundStyle(Color.black)
                            .font(.cursive(.bold, size: 90))
                            .padding(.top, 30)
                    }
                })
                .padding(.leading, 100)
                .padding(.vertical, 300)
                .padding(.trailing, 25)
                
                Button(action: {
                    router.push(.description)
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 100)
                            .fill(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 100.0)
                                    .stroke(Color.black, lineWidth: 10)
                            )
                            
                        Text("Gimpop List")
                            .foregroundStyle(Color.black)
                            .font(.cursive(.bold, size: 90))
                            .padding(.top, 30)
                    }
                })
                .padding(.trailing, 100)
                .padding(.vertical, 300)
                .padding(.leading, 25)
            }
        }
    }
}

#Preview {
    MainView(router: Router())
}
