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
                    .padding(.horizontal, 200)
            }
        }
    }
}

#Preview {
    InitialView()
}
