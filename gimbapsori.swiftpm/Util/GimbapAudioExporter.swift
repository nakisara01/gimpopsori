//
//  GimbapAudioExporter.swift
//  gimbapsori
//
//  Created by OpenAI Assistant on 2/22/26.
//

import AVFoundation
import Foundation

final class GimbapAudioExporter {
    enum ExportError: LocalizedError {
        case noTracks
        case resourceMissing(String)
        case engineStartFailed(Error)
        case fileCreationFailed
        case writingFailed
        
        var errorDescription: String? {
            switch self {
            case .noTracks:
                return "내보낼 수 있는 음원이 없습니다."
            case .resourceMissing(let name):
                return "음원 파일 \(name)을(를) 찾을 수 없습니다."
            case .engineStartFailed(let error):
                return "오디오 엔진을 시작할 수 없습니다: \(error.localizedDescription)"
            case .fileCreationFailed:
                return "출력 파일을 만들 수 없습니다."
            case .writingFailed:
                return "파일을 기록하는 중 문제가 발생했습니다."
            }
        }
    }
    
    func exportMix(for ingredients: [Ingredient], includeBase: Bool = true, fileName: String? = nil, completion: @escaping (Result<URL, Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let url = try self.performExport(ingredients: ingredients, includeBase: includeBase, fileName: fileName)
                DispatchQueue.main.async {
                    completion(.success(url))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func performExport(ingredients: [Ingredient], includeBase: Bool, fileName: String?) throws -> URL {
        let resourceNames = trackNames(for: ingredients, includeBase: includeBase)
        guard !resourceNames.isEmpty else { throw ExportError.noTracks }
        let engine = AVAudioEngine()
        var playerNodes: [AVAudioPlayerNode] = []
        var audioFiles: [AVAudioFile] = []
        var missingResource: String?
        for resource in resourceNames {
            guard let fileURL = Self.locateAudioResource(named: resource) else {
                missingResource = resource
                break
            }
            let file = try AVAudioFile(forReading: fileURL)
            let node = AVAudioPlayerNode()
            engine.attach(node)
            engine.connect(node, to: engine.mainMixerNode, format: file.processingFormat)
            playerNodes.append(node)
            audioFiles.append(file)
        }
        if let missing = missingResource {
            throw ExportError.resourceMissing(missing)
        }
        let outputFormat = engine.mainMixerNode.outputFormat(forBus: 0)
        let outputURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("\(sanitizedFileName(from: fileName)).caf")
        guard let outputFile = try? AVAudioFile(forWriting: outputURL, settings: outputFormat.settings) else {
            throw ExportError.fileCreationFailed
        }
        var writingError: Error?
        let group = DispatchGroup()
        for (index, node) in playerNodes.enumerated() {
            let file = audioFiles[index]
            group.enter()
            node.scheduleFile(file, at: nil) {
                group.leave()
            }
        }
        engine.mainMixerNode.installTap(onBus: 0, bufferSize: 4096, format: outputFormat) { buffer, _ in
            do {
                try outputFile.write(from: buffer)
            } catch {
                writingError = error
            }
        }
        do {
            try engine.start()
        } catch {
            engine.mainMixerNode.removeTap(onBus: 0)
            throw ExportError.engineStartFailed(error)
        }
        playerNodes.forEach { $0.play() }
        let semaphore = DispatchSemaphore(value: 0)
        group.notify(queue: .global()) {
            engine.mainMixerNode.removeTap(onBus: 0)
            playerNodes.forEach { $0.stop() }
            engine.stop()
            semaphore.signal()
        }
        semaphore.wait()
        if let error = writingError {
            throw error
        }
        return outputURL
    }
    
    private func trackNames(for ingredients: [Ingredient], includeBase: Bool) -> [String] {
        var names: [String] = []
        var seen: Set<String> = []
        if includeBase {
            names.append("GimbapBase")
        }
        for ingredient in ingredients {
            guard let resource = ingredient.audioTrackResourceName else { continue }
            if !seen.contains(resource) {
                seen.insert(resource)
                names.append(resource)
            }
        }
        return names
    }
    
    private static func locateAudioResource(named name: String) -> URL? {
        let exts = ["wav", "mp3", "m4a"]
        for ext in exts {
            if let url = Bundle.main.url(forResource: name, withExtension: ext) {
                return url
            }
        }
        return nil
    }
    
    private func sanitizedFileName(from raw: String?) -> String {
        let fallback = "GimbapMix"
        guard let raw, !raw.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return fallback + "-\(UUID().uuidString)" }
        let allowed = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "-_"))
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        let converted = trimmed.unicodeScalars.map { allowed.contains($0) ? Character($0) : "-" }
        let collapsed = String(converted).replacingOccurrences(of: "--", with: "-")
        return collapsed + "-\(UUID().uuidString.prefix(6))"
    }
}
