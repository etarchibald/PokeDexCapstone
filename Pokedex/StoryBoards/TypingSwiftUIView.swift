//
//  TypingSwiftUIView.swift
//  Pokedex
//
//  Created by Jacob Davis on 4/29/24.
//

import SwiftUI

struct TypingSwiftUIView: View {
    var types: [PokemonType]
    var isStrengths: Bool
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        VStack {
            if !types.isEmpty {
                LazyVGrid(columns: columns, content: {
                    setupGrid(for: types)
                })
            } else if isStrengths {
                Text("No Strengths")
            } else {
                Text("No Weaknesses")
            }
        }
        .padding()
        .frame(width: 350)
        .background(.gray.opacity(0.25), in: RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 5)
        
    }
}

#Preview {
    TypingSwiftUIView(types: [.ice, .dark, .bug, .dragon, .electric, .fairy, .fighting, .fire, .ground, .flying, .ghost, .grass, .poison, .psychic, .rock, .steel, .normal], isStrengths: true )
}

//@ViewBuilder
func setupGrid(for types: [PokemonType]) -> some View {
    let whiteRequired: [PokemonType] = [.dark, .fighting, .ghost, .poison]
    
    return ForEach(types, id: \.self) { type in
        let backgroundHex = PokemonPrettyController.shared.getBackgroundColorHex(type: type).dropFirst()
        let color = Color(hex: String(backgroundHex))
        
        Text(type.rawValue.capitalized)
            .foregroundStyle(whiteRequired.contains(type) ? .white : .black)
            .frame(width: 75)
            .padding(10)
            .background(color, in: RoundedRectangle(cornerRadius: 10))
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgb: UInt64 = 0
        
        scanner.scanHexInt64(&rgb)
        
        self.init(
            .sRGB,
            red: Double((rgb >> 16) & 0xFF) / 255.0,
            green: Double((rgb >> 8) & 0xFF) / 255.0,
            blue: Double(rgb & 0xFF) / 255.0
        )
    }
}

