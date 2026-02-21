//
//  DescriptionView.swift
//  gimbapsori
//
//  Created by 나현흠 on 2/16/26.
//

import SwiftUI

struct DescriptionView: View {
    let router: Router
    
    var body: some View {
        ZStack {
            Image("GimPopSori_Background")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            
            Color.white.opacity(0.6)
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Text("김밥소리 메뉴")
                    .font(.cursive(.bold, size: 72))
                    .foregroundColor(.black)
                    .padding(.top, 80)
                
                VStack(alignment: .leading, spacing: 24) {
                    infoRow(title: "김과 밥", detail: "국악 Incredibox의 베이스가 되는 기본 그루브")
                    infoRow(title: "재료", detail: "태평소, 대금, 해금 등 각각의 악기가 식재료로 준비돼요")
                    infoRow(title: "나만의 레이어", detail: "끌어다가 쌓으면 국악 합주가 펼쳐지는 체험")
                }
                .padding()
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 48, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 48)
                        .stroke(Color.black.opacity(0.15), lineWidth: 1)
                )
                .padding(.horizontal, 120)
                
                Button(action: {
                    router.pop()
                }, label: {
                    Text("돌아가기")
                        .foregroundColor(.black)
                        .font(.cursive(.bold, size: 48))
                        .padding(.horizontal, 80)
                        .padding(.vertical, 24)
                        .background(
                            RoundedRectangle(cornerRadius: 60)
                                .fill(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 60)
                                        .stroke(Color.black, lineWidth: 6)
                                )
                        )
                })
                .padding(.bottom, 120)
            }
            .padding()
        }
    }
    
    private func infoRow(title: String, detail: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.cursive(.bold, size: 48))
            Text(detail)
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(.black.opacity(0.75))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    DescriptionView(router: Router())
}
