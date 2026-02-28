//
//  MakeView.swift
//  gimbapsori
//
//  Created by 나현흠 on 2/17/26.
//

import SwiftUI

struct MakeView: View {
    let router: Router?
    @StateObject private var viewModel: MakeViewModel
    private let boardLayerHeight: CGFloat = 78
    private let boardLayerSpacing: CGFloat = -28
    @State private var boardIsTargeted: Bool = false
    @State private var trashIsTargeted: Bool = false
    @State private var presentedIngredientForUnlock: Ingredient?
    
    private var rolledGimbapBinding: Binding<CompletedGimbap?> {
        Binding(
            get: { viewModel.rolledGimbap },
            set: { newValue in
                if newValue == nil {
                    viewModel.resetRolledGimbap()
                }
            }
        )
    }
    
    init(router: Router? = nil, viewModel: MakeViewModel = MakeViewModel()) {
        self.router = router
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
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
                
                HStack(alignment: .top, spacing: 36) {
                    paletteView
                    gimbapBoard
                }
                
                trashDropArea
            }
            .padding(.horizontal, 72)
            .padding(.vertical, 40)
        }
        .fullScreenCover(item: rolledGimbapBinding) { gimbap in
            GimbapDetailView(
                gimbap: gimbap,
                router: router,
                onClose: viewModel.resetRolledGimbap,
                onNameChange: viewModel.updateRolledGimbapName
            )
        }
        .fullScreenCover(item: $presentedIngredientForUnlock) { ingredient in
            IngredientUnlockView(
                ingredient: ingredient,
                isNext: viewModel.isNextToUnlock(ingredient),
                onUnlock: {
                    viewModel.unlock(ingredient)
                    presentedIngredientForUnlock = nil
                },
                onClose: {
                    presentedIngredientForUnlock = nil
                }
            )
        }
    }
    
    private var header: some View {
        VStack(spacing: 12) {
            Text("Build Your Own Gugak Gimbap")
                .font(.cursive(.bold, size: 70))
                .foregroundColor(.black)
            
            Text("Layer ingredients on rice and let traditional instruments sing.")
                .font(.system(size: 22))
                .foregroundColor(.black.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
    }
    
    private var paletteView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Ingredients")
                .font(.cursive(.bold, size: 40))
            Text("Drag items onto the board.")
                .font(.system(size: 16))
                .foregroundColor(.black.opacity(0.6))
            ScrollView {
                VStack(spacing: 18) {
                    ForEach(viewModel.palette) { ingredient in
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
        let isUsed = viewModel.hasUsed(ingredient)
        let isUnlocked = viewModel.isIngredientUnlocked(ingredient)
        return VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 12) {
                Group {
                    if let asset = ingredient.imageAssetName {
                        Image(asset)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 48, height: 48)
                    } else {
                        Text(ingredient.icon)
                            .font(.system(size: 40))
                    }
                }
                .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: -8) {
                    Text(ingredient.name)
                        .font(.cursive(.bold, size: 28))
                    Text(ingredient.instrument)
                        .font(.system(size: 15))
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
        .opacity(isUnlocked ? 1 : 0.35)
        .overlay {
            if isUsed {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.7))
                    .overlay(
                        Text("Used")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.black.opacity(0.65))
                    )
                    .allowsHitTesting(false)
            } else if !isUnlocked {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.black.opacity(0.05))
                    .overlay(
                        Text("Locked")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.black.opacity(0.6))
                    )
                    .allowsHitTesting(false)
            }
        }
        .overlay(alignment: .topTrailing) {
            Button {
                presentedIngredientForUnlock = ingredient
            } label: {
                Image(systemName: "info.circle")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black.opacity(0.7))
                    .padding(10)
                    .accessibilityLabel(Text("Information about \(ingredient.name)"))
            }
        }
        .onTapGesture {
            if isUnlocked {
                viewModel.select(ingredient)
            } else {
                presentedIngredientForUnlock = ingredient
            }
        }
        .conditionalDrag(isEnabled: !isUsed && isUnlocked) {
            viewModel.dragIdentifier(for: ingredient)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(ingredientAccessibilityLabel(for: ingredient)))
        .accessibilityHint(Text(paletteAccessibilityHint(isUnlocked: isUnlocked, isUsed: isUsed)))
        .accessibilityAddTraits(.isButton)
    }
    
    private var gimbapBoard: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .lastTextBaseline) {
                Text("Gimbap Board")
                    .font(.cursive(.bold, size: 44))
                Spacer()
                Text("Total \(viewModel.gimbapLayers.count) layers")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black.opacity(0.6))
            }
            
            ZStack {
                Image("GimBapBase")
                    .resizable()
                    .scaledToFit()
                    .accessibilityHidden(true)
                    .padding(.horizontal, 40)
                    .shadow(color: .black.opacity(0.2), radius: 25, x: 0, y: 20)
                
                if viewModel.gimbapLayers.isEmpty {
                    Text("Drag ingredients to build your own soundscape")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black.opacity(0.5))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 80)
                } else {
                    ingredientOverlay
                }
                
                if viewModel.isRolling {
                    Color.black.opacity(0.4)
                        .overlay(
                            VStack(spacing: 12) {
                                ProgressView()
                                    .tint(.white)
                                Text("Rolling your gimbap...")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 60, style: .continuous))
                        .padding(.horizontal, 36)
                }
            }
            .frame(height: 420)
            .frame(maxWidth: .infinity)
            .onDrop(of: [viewModel.dropType], isTargeted: $boardIsTargeted) { providers in
                viewModel.handleDrop(providers, destination: .board)
            }
            
            rollButton
        }
        .padding(28)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 48, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 48)
                .stroke(boardIsTargeted ? Color.black : Color.black.opacity(0.15), lineWidth: 2)
        )
        .frame(maxWidth: .infinity)
    }
    
    private var ingredientOverlay: some View {
        VStack(spacing: boardLayerSpacing) {
            ForEach(viewModel.gimbapLayers) { placement in
                interactiveLayer(for: placement)
            }
        }
        .padding(.horizontal, 70)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .animation(.easeInOut(duration: 0.35), value: viewModel.gimbapLayers.count)
    }
    
    private func interactiveLayer(for placement: IngredientPlacement) -> some View {
        let ingredient = placement.ingredient
        return Group {
            if let asset = placement.ingredient.imageAssetName {
                let scaledHeight = boardLayerHeight * ingredient.boardLayerScale
                Image(asset)
                    .resizable()
                    .scaledToFit()
                    .frame(height: scaledHeight)
                    .frame(maxWidth: .infinity)
                    .accessibilityHidden(true)
            } else {
                layerView(for: placement)
            }
        }
        .onTapGesture {
            viewModel.select(placement.ingredient)
        }
        .conditionalDrag(isEnabled: true) {
            viewModel.dragIdentifier(for: placement)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(ingredientAccessibilityLabel(for: ingredient)))
        .accessibilityHint(Text("Double tap to highlight. Drag to trash to remove."))
        .accessibilityAddTraits(.isButton)
    }
    
    private func layerView(for placement: IngredientPlacement) -> some View {
        HStack(spacing: 12) {
            Text(placement.ingredient.icon)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: -2) {
                Text(placement.ingredient.name)
                    .font(.cursive(.bold, size: 26))
                Text(placement.ingredient.instrument)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black.opacity(0.8))
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .frame(height: boardLayerHeight * placement.ingredient.boardLayerScale)
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
                .stroke(Color.white.opacity(0.4), lineWidth: viewModel.selectedIngredient?.id == placement.ingredient.id ? 4 : 1)
        )
        .onTapGesture {
            viewModel.select(placement.ingredient)
        }
        .conditionalDrag(isEnabled: true) {
            viewModel.dragIdentifier(for: placement)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(ingredientAccessibilityLabel(for: placement.ingredient)))
        .accessibilityHint(Text("Double tap to highlight. Drag to trash to remove."))
    }
    
    private var trashDropArea: some View {
        HStack(spacing: 12) {
            Image(systemName: "trash")
                .font(.system(size: 26, weight: .semibold))
            Text("Drop layers here to delete them")
                .font(.system(size: 18))
        }
        .padding(.horizontal, 28)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(trashIsTargeted ? Color.red.opacity(0.2) : Color.black.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .onDrop(of: [viewModel.dropType], isTargeted: $trashIsTargeted) { providers in
            viewModel.handleDrop(providers, destination: .trash)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text("Trash area"))
        .accessibilityHint(Text("Drag layers here to delete them"))
    }
    
    private var rollButton: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button(action: viewModel.rollGimbap) {
                HStack(spacing: 12) {
                    Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                        .font(.system(size: 28, weight: .medium))
                    Text(viewModel.canRoll ? "Roll the Gimbap" : "Add unique ingredients to roll")
                        .font(.cursive(.bold, size: 28))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 28)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(colors: [Color(hex: "050505"), Color(hex: "292929")], startPoint: .leading, endPoint: .trailing)
                )
                .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
            }
            .disabled(!viewModel.canRoll)
            .opacity(viewModel.canRoll ? 1 : 0.5)
            
            Text("Each ingredient can be used once. Rolling saves your creation.")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.black.opacity(0.6))
        }
        .accessibilityElement(children: .combine)
        .accessibilityHint(Text(viewModel.canRoll ? "Double tap to save and name your gimbap." : "Add at least one ingredient to roll."))
    }
    
    private func ingredientAccessibilityLabel(for ingredient: Ingredient) -> String {
        "\(ingredient.name), instrument: \(ingredient.instrument)"
    }
    
    private func paletteAccessibilityHint(isUnlocked: Bool, isUsed: Bool) -> String {
        if !isUnlocked {
            return "Locked ingredient. Double tap to learn how to unlock."
        }
        if isUsed {
            return "Already added to the board."
        }
        return "Double tap to select. Long press to drag onto the board."
    }
}

private struct ConditionalDragModifier: ViewModifier {
    let isEnabled: Bool
    let provider: () -> NSString
    
    func body(content: Content) -> some View {
        if isEnabled {
            if #available(iOS 16.0, *) {
                content.draggable(provider() as String)
            } else {
                content.onDrag { NSItemProvider(object: provider()) }
            }
        } else {
            content
        }
    }
}

private extension View {
    func conditionalDrag(isEnabled: Bool, provider: @escaping () -> NSString) -> some View {
        modifier(ConditionalDragModifier(isEnabled: isEnabled, provider: provider))
    }
}

#Preview {
    MakeView(router: Router())
}
