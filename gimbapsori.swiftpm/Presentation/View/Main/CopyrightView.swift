//
//  CopyrightView.swift
//  gimbapsori
//
//  Created by OpenAI Assistant on 2/22/26.
//

import SwiftUI

struct CopyrightView: View {
    let router: Router
    
    private let paragraphs: [String] = [
        "This application includes traditional Korean instrument sounds generated using the virtual instrument library developed by the Arts & Science Center at Seoul National University (CATSNU).",
        "The library is publicly available for non-commercial use.",
        "All compositions and arrangements within this app were created by the developer as original derivative works using the above library.",
        "Seoul National University Arts & Science Center\nhttp://www.catsnu.com\nContact: catatsnu@gmail.com",
        "All visual assets in this application were generated using AI-based image generation tools and curated, edited, and arranged by the developer.\nNo third-party copyrighted images were directly used.",
        "All other design, code, interaction systems, and audio structuring were independently developed for this project."
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: "F8F5EE"), Color.white], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Credits & Usage")
                        .font(.cursive(.bold, size: 60))
                        .foregroundColor(.black)
                    VStack(alignment: .leading, spacing: 18) {
                        ForEach(paragraphs, id: \.self) { paragraph in
                            Text(paragraph)
                                .font(.system(size: 17, weight: .medium))
                                .foregroundColor(.black.opacity(0.85))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.9), in: RoundedRectangle(cornerRadius: 28, style: .continuous))
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 30)
            }
        }
    }
}

#Preview {
    CopyrightView(router: Router())
}
