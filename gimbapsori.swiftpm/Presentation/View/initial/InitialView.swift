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
                
                HStack(spacing: 24) {
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
                    .frame(maxWidth: 400)
                    
                    Button(action: {
                        router.push(.copyright)
                    }, label: {
                        VStack(spacing: 6) {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 42, weight: .semibold))
                            Text("Credits")
                                .font(.system(size: 22, weight: .semibold))
                        }
                        .foregroundColor(.black)
                        .padding(24)
                        .frame(minWidth: 180)
                        .background(Color.white.opacity(0.9), in: RoundedRectangle(cornerRadius: 40, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(Color.black.opacity(0.2), lineWidth: 2)
                        )
                    })
                }
                .padding(.top, 100)
                .padding(.horizontal, 80)
                .padding(.bottom, 300)
            }
        }
    }
}

#Preview {
    InitialView(router: Router())
}
