//
//  MakeView.swift
//  gimbapsori
//
//  Created by 나현흠 on 2/17/26.
//

import SwiftUI
import UniformTypeIdentifiers

struct IngredientPlacement: Identifiable, Hashable {
    let id: UUID = .init()
    let ingredient: Ingredient
}

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

struct MakeView: View {
    @State private var gimbapLayers: [IngredientPlacement] = []
    @State private var selectedIngredient: Ingredient?
    @State private var boardIsTargeted: Bool = false
    @State private var trashIsTargeted: Bool = false
    
    private let palette: [Ingredient] = Ingredient.palette
    private let dropType = UTType.plainText
    
    var body: some View {
        ZStack {
            Image("GimPopSori_Background")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            
            Color.white.opacity(0.65)
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                header
                
                HStack(spacing: 32) {
                    paletteView
                    gimbapBoard
                    inspector
                }
                
                trashDropArea
            }
            .padding(.horizontal, 72)
            .padding(.vertical, 40)
        }
    }
    
    private var header: some View {
        VStack(spacing: 12) {
            Text("나만의 국악 김밥")
                .font(.cursive(.bold, size: 70))
                .foregroundColor(.black)
            
            Text("김과 밥 위에 원하는 재료를 올려 우리 악기의 소리를 얹어 보세요.")
                .font(.cursive(.medium, size: 32))
                .foregroundColor(.black.opacity(0.7))
        }
    }
    
    private var paletteView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("재료")
                .font(.cursive(.bold, size: 40))
                .foregroundColor(.black)
                
            Text("끌어다가 김밥 위에 올려보세요.")
                .font(.cursive(.medium, size: 26))
                .foregroundColor(.black.opacity(0.6))
            
            ScrollView {
                VStack(spacing: 18) {
                    ForEach(palette) { ingredient in
                        paletteCard(for: ingredient)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .padding(24)
        .frame(width: 300, alignment: .topLeading)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 32, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 32)
                .stroke(Color.black.opacity(0.15), lineWidth: 1)
        )
    }
    
    private func paletteCard(for ingredient: Ingredient) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(ingredient.icon)
                    .font(.system(size: 40))
                VStack(alignment: .leading, spacing: 4) {
                    Text(ingredient.name)
                        .font(.cursive(.bold, size: 28))
                    Text(ingredient.instrument)
                        .font(.cursive(.medium, size: 22))
                        .foregroundColor(.black.opacity(0.7))
                }
                Spacer()
            }
            Text(ingredient.description)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.black.opacity(0.75))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(ingredient.color.opacity(0.12))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(ingredient.color, lineWidth: 2)
        )
        .cornerRadius(20)
        .onTapGesture {
            selectedIngredient = ingredient
        }
        .onDrag {
            NSItemProvider(object: dragIdentifier(for: ingredient))
        }
    }
    
    private var gimbapBoard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .lastTextBaseline) {
                Text("김밥 베이스")
                    .font(.cursive(.bold, size: 44))
                Spacer()
                Text("총 \(gimbapLayers.count) 레이어")
                    .font(.cursive(.medium, size: 24))
                    .foregroundColor(.black.opacity(0.6))
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 100)
                    .fill(Color(hex: "050505"))
                    .shadow(color: .black.opacity(0.2), radius: 15, x: 0, y: 20)
                
                RoundedRectangle(cornerRadius: 80)
                    .fill(Color(hex: "F8F5EB"))
                    .padding(24)
                
                VStack(spacing: 12) {
                    if gimbapLayers.isEmpty {
                        Text("재료를 드래그해 나만의 소리를 쌓아보세요")
                            .font(.cursive(.medium, size: 30))
                            .foregroundColor(.black.opacity(0.5))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 60)
                    } else {
                        ForEach(gimbapLayers) { placement in
                            layerView(for: placement)
                        }
                    }
                    Spacer()
                }
                .padding(40)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 540)
            .onDrop(of: [dropType.identifier], isTargeted: $boardIsTargeted) { providers in
                handleDrop(providers, destination: .board)
            }
        }
        .padding(28)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 48, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 48)
                .stroke(boardIsTargeted ? Color.black : Color.black.opacity(0.15), lineWidth: 2)
        )
    }
    
    private func layerView(for placement: IngredientPlacement) -> some View {
        HStack {
            Text(placement.ingredient.icon)
            VStack(alignment: .leading, spacing: 2) {
                Text(placement.ingredient.name)
                    .font(.cursive(.bold, size: 26))
                Text(placement.ingredient.instrument)
                    .font(.cursive(.medium, size: 20))
                    .opacity(0.8)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .frame(height: 58)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [placement.ingredient.color.opacity(0.95), placement.ingredient.accentColor.opacity(0.85)]),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 32)
                .stroke(Color.white.opacity(0.4), lineWidth: selectedIngredient?.id == placement.ingredient.id ? 4 : 1)
        )
        .onTapGesture {
            selectedIngredient = placement.ingredient
        }
        .onDrag {
            NSItemProvider(object: dragIdentifier(for: placement))
        }
    }
    
    private var inspector: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("사운드 노트")
                .font(.cursive(.bold, size: 36))
            
            if let selected = selectedIngredient {
                VStack(alignment: .leading, spacing: 10) {
                    Text("\(selected.name) = \(selected.instrument)")
                        .font(.cursive(.bold, size: 30))
                    Text(selected.description)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.black.opacity(0.75))
                    
                    Text("드래그해서 다른 자리에 복사하거나 아래로 끌어버리면 삭제돼요.")
                        .font(.system(size: 15))
                        .foregroundColor(.black.opacity(0.5))
                        .padding(.top, 8)
                }
            } else {
                Text("레이어를 눌러 어떤 악기가 연주되는지 확인해요.")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.black.opacity(0.65))
            }
            Spacer()
        }
        .padding(24)
        .frame(width: 320, alignment: .topLeading)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 32, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 32)
                .stroke(Color.black.opacity(0.1), lineWidth: 1)
        )
    }
    
    private var trashDropArea: some View {
        HStack(spacing: 12) {
            Image(systemName: "trash")
                .font(.system(size: 26, weight: .semibold))
            Text("여기로 끌어놓으면 레이어가 삭제돼요")
                .font(.cursive(.medium, size: 26))
        }
        .padding(.horizontal, 28)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(trashIsTargeted ? Color.red.opacity(0.2) : Color.black.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .onDrop(of: [dropType.identifier], isTargeted: $trashIsTargeted) { providers in
            handleDrop(providers, destination: .trash)
        }
    }

    private enum DropDestination {
        case board
        case trash
    }
    
    private func handleDrop(_ providers: [NSItemProvider], destination: DropDestination) -> Bool {
        guard let provider = providers.first(where: { $0.hasItemConformingToTypeIdentifier(dropType.identifier) }) else {
            return false
        }
        provider.loadObject(ofClass: NSString.self) { string, _ in
            guard let rawString = string as? String as String?, let payload = DragPayload(rawValue: rawString) else { return }
            DispatchQueue.main.async {
                switch (destination, payload) {
                case (.board, .palette(let ingredientId)):
                    appendIngredient(with: ingredientId)
                case (.trash, .placement(let id)):
                    removePlacement(with: id)
                default:
                    break
                }
            }
        }
        return true
    }
    
    private func appendIngredient(with id: String) {
        guard let ingredient = palette.first(where: { $0.id == id }) else { return }
        withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
            let placement = IngredientPlacement(ingredient: ingredient)
            gimbapLayers.append(placement)
            selectedIngredient = ingredient
        }
    }
    
    private func removePlacement(with id: UUID) {
        guard let index = gimbapLayers.firstIndex(where: { $0.id == id }) else { return }
        withAnimation(.easeInOut(duration: 0.25)) {
            gimbapLayers.remove(at: index)
            if let selected = selectedIngredient, !gimbapLayers.contains(where: { $0.ingredient.id == selected.id }) {
                selectedIngredient = gimbapLayers.last?.ingredient
            }
        }
    }
    
    private func dragIdentifier(for ingredient: Ingredient) -> NSString {
        NSString(string: "palette:\(ingredient.id)")
    }
    
    private func dragIdentifier(for placement: IngredientPlacement) -> NSString {
        NSString(string: "placement:\(placement.id.uuidString)")
    }
}

#Preview {
    MakeView()
}
