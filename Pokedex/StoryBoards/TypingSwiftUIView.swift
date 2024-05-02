//
//  TypingSwiftUIView.swift
//  Pokedex
//
//  Created by Jacob Davis on 4/29/24.
//

import SwiftUI

struct TypingSwiftUIView: View {
    var strengths: [PokemonType]
    var weaknesses: [PokemonType]
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                VStack {
                    Text("Strengths")
                        .font(.largeTitle)
                        
                    LazyVGrid(columns: columns, content: {
                        setupGrid(for: strengths)
                    })
                    
                }
                .padding()
                .frame(width: 350)
                .background(.gray.opacity(0.7), in: RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 5)
                
                VStack {
                    Text("Weaknesses")
                        .font(.largeTitle)
                    
                    LazyVGrid(columns: columns, content: {
                        setupGrid(for: weaknesses)
                    })
                }
                .padding()
                .frame(width: 350)
                .background(.gray.opacity(0.7), in: RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 5)
                
            }
            .scrollTargetLayout()
        }
        .contentMargins(16, for: .scrollContent)
        .scrollTargetBehavior(.viewAligned)
        
    }
}

#Preview {
    TypingSwiftUIView(strengths: [.ice, .dark, .bug, .dragon, .electric, .fairy, .fighting, .fire, .ground, .flying, .ghost, .grass, .poison, .psychic, .rock, .steel, .normal], weaknesses: [.ice, .dark, .bug, .dragon, .electric, .fairy, .fighting, .fire, .ground, .flying, .ghost, .grass, .poison, .psychic, .rock, .steel, .normal] )
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

