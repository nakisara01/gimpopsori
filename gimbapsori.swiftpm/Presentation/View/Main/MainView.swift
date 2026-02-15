//
//  MainView.swift
//  gimbapsori
//
//  Created by 나현흠 on 2/16/26.
//

import SwiftUI

struct MainView: View {
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
                Button(action: {}, label: {
                    ZStack {
                        Image("Button")
                            .resizable()
                            .scaledToFill()
                        Text("Go To Kitchen")
                            .foregroundStyle(Color.black)
                            .font(.cursive(.bold, size: 90))
                            .padding(.top, 30)
                    }
                })
                .padding(.leading, 100)
                .padding(.vertical, 500)
                Button(action: {}, label: {
                    ZStack {
                        Image("Button")
                            .resizable()
                            .scaledToFill()
                        Text("Gimbap List")
                            .foregroundStyle(Color.black)
                            .font(.cursive(.bold, size: 90))
                            .padding(.top, 30)
                    }
                })
                .padding(.trailing, 100)
                .padding(.vertical, 500)
            }
        }
    }
}

#Preview {
    MainView()
}
