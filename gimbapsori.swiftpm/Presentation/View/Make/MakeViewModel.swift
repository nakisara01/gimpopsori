//
//  MakeViewModel.swift
//  gimbapsori
//
//  Created by OpenAI Assistant on 2/18/26.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

enum MakeDropDestination {
    case board
    case trash
}

@MainActor
final class MakeViewModel: ObservableObject {
    @Published private(set) var model: MakeModel
    @Published private(set) var isRolling: Bool = false
    @Published private(set) var rolledGimbap: CompletedGimbap?
    let palette: [Ingredient]
    let dropType: UTType = .plainText
    private let storage: GimbapStorage
    private static let nameFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, HH:mm"
        return formatter
    }()
    
    private enum DragPayload {
        case palette(String)
        case placement(UUID)
        
        init?(rawValue: String) {
            let components = rawValue.split(separator: ":", maxSplits: 1).map(String.init)
            guard components.count == 2 else { return nil }
            switch components[0] {
            case "palette":
                self = .palette(components[1])
            case "placement":
                guard let uuid = UUID(uuidString: components[1]) else { return nil }
                self = .placement(uuid)
            default:
                return nil
            }
        }
    }
    
    init(model: MakeModel = MakeModel(), palette: [Ingredient] = Ingredient.palette, storage: GimbapStorage = .shared) {
        self.model = model
        self.palette = palette
        self.storage = storage
    }
    
    var gimbapLayers: [IngredientPlacement] {
        model.layers
    }
    
    var selectedIngredient: Ingredient? {
        model.selectedIngredient
    }
    
    var canRoll: Bool {
        !model.layers.isEmpty && !isRolling
    }
    
    private var usedIngredientIDs: Set<String> {
        Set(model.layers.map { $0.ingredient.id })
    }
    
    func select(_ ingredient: Ingredient?) {
        model.selectedIngredient = ingredient
    }
    
    func hasUsed(_ ingredient: Ingredient) -> Bool {
        usedIngredientIDs.contains(ingredient.id)
    }
    
    func handleDrop(_ providers: [NSItemProvider], destination: MakeDropDestination) -> Bool {
        guard let provider = providers.first(where: { $0.hasItemConformingToTypeIdentifier(dropType.identifier) }) else {
            return false
        }
        provider.loadObject(ofClass: NSString.self) { string, _ in
            guard let rawString = string as? String as String?, let payload = DragPayload(rawValue: rawString) else { return }
            Task { @MainActor in
                switch (destination, payload) {
                case (.board, .palette(let ingredientId)):
                    self.appendIngredient(with: ingredientId)
                case (.trash, .placement(let id)):
                    self.removePlacement(with: id)
                default:
                    break
                }
            }
        }
        return true
    }
    
    func dragIdentifier(for ingredient: Ingredient) -> NSString {
        NSString(string: "palette:\(ingredient.id)")
    }
    
    func dragIdentifier(for placement: IngredientPlacement) -> NSString {
        NSString(string: "placement:\(placement.id.uuidString)")
    }
    
    private func appendIngredient(with id: String) {
        guard let ingredient = palette.first(where: { $0.id == id }), !usedIngredientIDs.contains(id) else { return }
        rolledGimbap = nil
        withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
            let placement = IngredientPlacement(ingredient: ingredient)
            model.layers.append(placement)
            model.selectedIngredient = ingredient
        }
    }
    
    private func removePlacement(with id: UUID) {
        guard let index = model.layers.firstIndex(where: { $0.id == id }) else { return }
        withAnimation(.easeInOut(duration: 0.25)) {
            model.layers.remove(at: index)
            if let selected = model.selectedIngredient,
               !model.layers.contains(where: { $0.ingredient.id == selected.id }) {
                model.selectedIngredient = model.layers.last?.ingredient
            }
        }
    }
    
    func rollGimbap() {
        guard canRoll else { return }
        isRolling = true
        let ingredients = model.layers.map { $0.ingredient }
        let defaultName = "Gugak Roll \(Self.nameFormatter.string(from: Date()))"
        let completed = CompletedGimbap(name: defaultName, ingredients: ingredients)
        storage.append(completed)
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            await MainActor.run {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.9)) {
                    self.model.layers.removeAll()
                    self.model.selectedIngredient = nil
                }
                self.isRolling = false
                self.rolledGimbap = completed
            }
        }
    }
    
    func resetRolledGimbap() {
        rolledGimbap = nil
    }
    
    func updateRolledGimbapName(_ name: String) {
        rolledGimbap?.name = name
    }
}
