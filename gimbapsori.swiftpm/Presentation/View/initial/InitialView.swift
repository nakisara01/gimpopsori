//
//  InitialView.swift
//  gimbapsori
//
//  Created by 나현흠 on 2/6/26.
//

import SwiftUI

struct InitialView: View {
    var backgroundColor: Color = .brown
    
    var body: some View {
        ZStack{
            Image("GimPopSori_Background")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            Color.white.opacity(0.6)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Image("GimPopSori_Logo")
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 100)
                
                Button(action: {}, label: {
                    ZStack {
                        Image("Button")
                            .resizable()
                            .scaledToFill()
                        Text("Start")
                            .foregroundStyle(Color.black)
                            .font(Font.largeTitle.bold())
                    }
                })
                .padding(.horizontal, 500)
                .padding(.top, 100)
                .padding(.bottom, 300)
            }
        }
    }
}

#Preview {
    InitialView()
}
