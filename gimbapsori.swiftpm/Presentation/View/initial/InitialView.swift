//
//  InitialView.swift
//  gimbapsori
//
//  Created by 나현흠 on 2/6/26.
//

import SwiftUI

struct InitialView: View {
    let router: Router
    
    var body: some View {
        ZStack{
            Image("GimPopSori_Background")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            
            Color.white.opacity(0.6)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Image("GimPopSori_Logo")
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 100)
                
                Button(action: {
                    router.push(.main)
                }, label: {
                    ZStack {
                        Image("Button")
                            .resizable()
                            .scaledToFill()
                        Text("Start")
                            .foregroundStyle(Color.black)
                            .font(.cursive(.bold, size: 90))
                            .padding(.top, 30)
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
    InitialView(router: Router())
}
