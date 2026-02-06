//
//  Typography.swift
//  gimbapsori
//
//  Created by 나현흠 on 2/6/26.
//

import SwiftUI
import CoreText

enum CursiveStyle {
    case bold
    case medium

    fileprivate var file: (name: String, ext: String) {
        switch self {
        case .bold:   return ("Cursive-Bold", "otf")
        case .medium: return ("Cursive-medium", "otf")
        }
    }
}

enum AppFontRegistrar {

    /// 파일에서 뽑은 PostScript name 캐시
    nonisolated(unsafe) private static var postScriptNameCache: [String: String] = [:]

    /// App 시작 시점에 1회 호출
    static func registerFonts() {
        register(style: .bold)
        register(style: .medium)
    }

    static func postScriptName(for style: CursiveStyle) -> String? {
        let key = "\(style.file.name).\(style.file.ext)"
        return postScriptNameCache[key]
    }

    private static func register(style: CursiveStyle) {
        let (fileName, fileExt) = style.file
        let key = "\(fileName).\(fileExt)"

        guard let url = Bundle.module.url(forResource: fileName, withExtension: fileExt) else {
            return
        }

        // 1) PostScript name을 파일에서 직접 뽑아 캐싱
        if let ps = extractPostScriptName(from: url) {
            postScriptNameCache[key] = ps
        }

        // 2) 시스템에 폰트 등록
        var error: Unmanaged<CFError>?
        let _ = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
    }

    private static func extractPostScriptName(from url: URL) -> String? {
        guard let provider = CGDataProvider(url: url as CFURL),
              let cgFont = CGFont(provider) else {
            return nil
        }
        return cgFont.postScriptName as String?
    }
}

extension Font {
    static func cursive(_ style: CursiveStyle, size: CGFloat) -> Font {
        if let ps = AppFontRegistrar.postScriptName(for: style) {
            return .custom(ps, size: size)
        }
        // 캐시가 비어있을 때(등록 호출 전/프리뷰 등) 임시 fallback
        let fallback = style.file.name
        return .custom(fallback, size: size)
    }
}

// 사용 예시
// Text("Hello").font(.cursive(.bold, size: 30))
